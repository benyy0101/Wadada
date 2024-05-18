package org.api.wadada.marathon.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.Synchronized;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.errorcode.ErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.api.wadada.marathon.dto.*;
import org.api.wadada.marathon.dto.req.MarathonCreateReq;
import org.api.wadada.marathon.dto.req.MarathonGameEndReq;
import org.api.wadada.marathon.dto.req.MarathonGameStartReq;
import org.api.wadada.marathon.dto.req.RequestDataReq;
import org.api.wadada.marathon.dto.res.*;
import org.api.wadada.marathon.entity.Marathon;
import org.api.wadada.marathon.entity.MarathonRecord;
import org.api.wadada.marathon.entity.Member;
import org.api.wadada.marathon.exception.NotFoundMemberException;
import org.api.wadada.marathon.repository.MarathonRecordRepository;
import org.api.wadada.marathon.repository.MemberRepository;
import org.api.wadada.marathon.repository.MarathonRepository;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.socket.messaging.SessionConnectEvent;

import java.security.Principal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.concurrent.*;

@Service
@Slf4j
@RequiredArgsConstructor
public class MarathonServiceImpl implements MarathonService {

    private final MarathonRepository marathonRepository;
    private final MarathonRecordRepository marathonRecordRepository;
    private final MarathonGameManager marathonGameManager;
    private final MemberRepository memberRepository;
   private  ScheduledExecutorService scheduledExecutor = Executors.newScheduledThreadPool(1);
    private ExecutorService executor = Executors.newCachedThreadPool();
    private Map<Integer, ScheduledExecutorService> roomSchedulers = new ConcurrentHashMap<>();

    @Override
    @Transactional
    public List<MainRes> getMarathonMain() {
        return marathonRepository.getMarathonList();

    }
    @Override
    @Transactional
    public List<MarathonMemberListRes> getMarathonMemberList(int marathonSeq) {
        return marathonRepository.getMarathonMemberList(marathonSeq);

    }

    @Override
    public List<MarthonRankListRes> getMarathonRankList(int marathonSeq) {
        return marathonRepository.getMarathonRankList(marathonSeq);
    }

    @Override
    public Integer startMarathon(Principal principal, MarathonCreateReq marathonCreateReq) {
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        if (optional.isEmpty()) {
            throw new NotFoundMemberException();
        }
        Member member = optional.get();
        if(!member.getMemberNickName().equals("123123")){
            try {
//                MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();
                //marathonRoomManager.addRoom(new MarathonRoomDto(freshmarathon.getMarathonSeq()));

                //추후 동시에 여러 마라톤 진행할 경우 해당 마라톤SEQ를 위와같이 넣어줘야 함
                Marathon freshmarathon;

                long delay = LocalDateTime.now().until(marathonCreateReq.getMarathonStart(), ChronoUnit.MILLIS);

                if (delay > 0) {

                    Marathon marathon = Marathon.builder().
                            marathonGoal(marathonCreateReq.getMarathonGoal()).
                            marathonStart(marathonCreateReq.getMarathonStart()).
                            marathonTitle(marathonCreateReq.getMarathonTitle()).marathonEnd(marathonCreateReq.getMarathonEnd())
                            .marathonText(marathonCreateReq.getMarathonText()).marathonParticipate(marathonCreateReq.getMarathonParticipate())
                            .marathonType(marathonCreateReq.getMarathonType())
                            .marathonDist(marathonCreateReq.getMarathonDist())
                            .marathonRound(marathonCreateReq.getMarathonRound()).build();
                    freshmarathon = marathonRepository.save(marathon);
                    marathonGameManager.CreateNewMarathonGame(marathonCreateReq.getMarathonStart(),marathonCreateReq.getMarathonEnd(),freshmarathon.getMarathonSeq());
                    MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();
                    scheduledExecutor.schedule(() -> {
                        System.out.println("LocalDateTime.now() = " + LocalDateTime.now());
                        marathonRoomManager.sendStartMessage();
                        CompletableFuture<Void> tasks = CompletableFuture.anyOf(
                                //모든사람이 들어왔으면 시작
                                CompletableFuture.runAsync(() -> {
                                    synchronized (marathonRoomManager) {
                                        while (marathonRoomManager.getREAL_cur_Person() < marathonRoomManager.getREAL_max_Person()) {
                                            try {
                                                  marathonRoomManager.wait();
                                            } catch (InterruptedException e) {
                                                Thread.currentThread().interrupt();
                                            }
                                        }
                                    }
                                }, executor),
                                //or 30초지나면 시작
                                CompletableFuture.runAsync(() -> {
                                    try {
                                        TimeUnit.SECONDS.sleep(30);
                                    } catch (InterruptedException e)     {
                                        Thread.currentThread().interrupt();
                                    }
                                }, executor)
                        ).thenRun(() -> {
                            marathonRoomManager.sendMessage();
                            try {
                                Thread.sleep(5000);
                                getPlayerRank(freshmarathon.getMarathonSeq());
                            } catch (InterruptedException e) {
                                throw new RuntimeException(e);
                            }
                        });

                    }, delay, TimeUnit.MILLISECONDS);
                }
                else{
                    freshmarathon = null;
                    throw new RestApiException(CustomErrorCode.MARATHON_ROOM_STARTTIME_INVAILD);
                }

                LocalDateTime now = LocalDateTime.now();
                LocalDateTime scheduledTime = marathonCreateReq.getMarathonEnd();

                // 현재 시간과 예정된 시간 사이의 차이(지연 시간)를 계산
                long delay2 = ChronoUnit.MILLIS.between(now, scheduledTime);

                // 지연 시간이 음수인 경우 (즉, 이미 지난 시간인 경우) 작업을 예약하지 않음
                if (delay2 > 0) {
                    scheduledExecutor.schedule(() -> stopPlayerRankUpdates(freshmarathon.getMarathonSeq()), delay2, TimeUnit.MILLISECONDS);
                }
                else{
                    throw new RestApiException(CustomErrorCode.MARATHON_ROOM_ENDTIME_INVAILD);
                }
                return freshmarathon.getMarathonSeq();
            } catch (Exception e) {
                throw new RestApiException(CustomErrorCode.MARATHON_ROOM_NOT_CREATED);
            }
        }
        throw new SecurityException();
    }

    @Override
    public Integer isMarathonReady(Principal principal,int marathonSeq) throws Exception {
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        if (optional.isEmpty()) {
            throw new NotFoundMemberException();
        }
        Member member = optional.get();

        MemberInfo memberInfo = MemberInfo.builder().MemberSeq(member.getMemberSeq())
                .MemberName(member.getMemberNickName())
                .image(member.getMemberProfileImage())
                .registTime(LocalDateTime.now()).build();

        //마라톤 SEQ에 해당하는 게임정보 확인
        MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();

        if (marathonRoomManager.isStarted() ||
                ZonedDateTime.of(marathonRoomManager.getStartTime(), ZoneId.systemDefault())
                        .isBefore(ZonedDateTime.now(ZoneId.systemDefault())) || marathonSeq != marathonRoomManager.getMarathonSeq()) {
            throw new RestApiException(CustomErrorCode.MARATHON_ROOM_NOT_ATTEND);
        }

        MarathonRecord marathonRecord = MarathonRecord.builder()
                .marathonSeq(marathonSeq)
                .member(member) // Member 인스턴스 설정
                .build();

        MarathonRecord optional1 = marathonRecordRepository.save(marathonRecord);

        //해당 게임에 Member 넣을 수 있으면 true 없으면 false
        if(marathonRoomManager.InsertMember(memberInfo)){
            return marathonRoomManager.getCurRooms();
        }
        return -1;
    }

    @Override
    public MarathonGameStartRes saveStartMarathon(Principal principal, MarathonGameStartReq marathonGameStartReq) {
        Optional<Member> memberOptional = memberRepository.getMemberByMemberId(principal.getName());
        if (memberOptional.isPresent()) {
            Member member = memberOptional.get();

            Optional<MarathonRecord> optional = marathonRepository.findByMemberIdandMarathonSeq(member.getMemberSeq(),marathonGameStartReq.getMarathonSeq());
            if(!optional.isPresent()){
                throw new RestApiException(CustomErrorCode.MARATHON_ROOM_NOT_ATTEND);
            }
            optional.get().updateStart(marathonGameStartReq.getMarathonRecordStart());

            MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();

            marathonRoomManager.increaseRealCurPerson();

            return new MarathonGameStartRes(optional.get().getMarathonRecordSeq());
        } else {
            throw new NotFoundMemberException();
        }

    }

    @Override
    public MarathonGameEndRes saveEndMarathon(Principal principal, MarathonGameEndReq marathonGameEndReq) {
        Optional<Member> memberOptional = memberRepository.getMemberByMemberId(principal.getName());
        if (memberOptional.isPresent()) {
            Member member = memberOptional.get();


            Optional<MarathonRecord> optional = marathonRepository.findByMemberIdandMarathonSeq(member.getMemberSeq(),marathonGameEndReq.getMarathonSeq());
            if(optional.isEmpty()){
                throw new NullPointerException("기록을 찾을 수 없습니다");
            }


            optional.get().updateEnd(marathonGameEndReq.getMarathonRecordEnd(),marathonGameEndReq.getMarathonRecordTime(),
                    marathonGameEndReq.getMarathonRecordDist(),marathonGameEndReq.getMarathonRecodeImage(),
                    marathonGameEndReq.getMarathonRecordRank(),
                    marathonGameEndReq.getMarathonRecodeWay(),
                    marathonGameEndReq.getMarathonRecodePace(),
                    marathonGameEndReq.getMarathonRecordSpeed(),
                    marathonGameEndReq.getMarathonRecordHeartbeat(),
                    marathonGameEndReq.isMarathonRecordIsWin());

            return new MarathonGameEndRes(optional.get().getMarathonRecordSeq());
        } else {
            throw new NotFoundMemberException();
        }
    }

    @Override
    public boolean isEndGame(int RoomSeq) {
        try {
            MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();

            marathonRoomManager.removeRoom(RoomSeq);
            return true;
        } catch (RestApiException e) {
            throw new RestApiException(CustomErrorCode.NO_ROOM);
        }
    }

    @Override
    public void savePlayerData(Principal principal, RequestDataReq requestDataReq) {

    }


    @Override
    public void getPlayerRank(int roomSeq) {
        roomSchedulers.computeIfAbsent(roomSeq, k -> Executors.newScheduledThreadPool(1))
                .scheduleAtFixedRate(() -> updatePlayRank(roomSeq), 0, 6, TimeUnit.SECONDS);
    }

    public void updatePlayRank(int roomSeq){

        MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();
        marathonRoomManager.sortMember();
        marathonRoomManager.makeSentence();
        marathonRoomManager.sendEndMessage();
    }
    // 종료 조건
    // (curConnection == MaxConnection) 자동 End API 호출  완주해도 늘어나고, 연결이 끊겨도 늘어남
    // || 누가 End API 호출
    public void stopPlayerRankUpdates(int marathonSeq) {
        log.info(marathonSeq+"게임이 종료되었습니다");
        //게임이 종료 되기 전 방 지우기
        Optional<Marathon> curMarathon = marathonRepository.findById(marathonSeq);
        if(!curMarathon.isPresent())
            throw new RestApiException(CustomErrorCode.NO_ROOM);
        curMarathon.get().deleteSoftly();
        marathonGameManager.RemoveMarathonGame();
        ScheduledExecutorService scheduler = roomSchedulers.remove(marathonSeq);
        if (scheduler != null) {
            scheduler.shutdown();
            try {
                if (!scheduler.awaitTermination(1, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }


    @EventListener
    public void isConnected(SessionConnectEvent sessionConnectEvent){
        MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();
        int[] seqList = new int[marathonRoomManager.getCurRooms()+1];

        for(int i=0; i<=marathonRoomManager.getCurRooms(); i++)
            seqList[i] = i;

        List<String> topics = new ArrayList<>();
        for(int i:seqList){
            topics.add("/sub/attend/"+i);
        }
        ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor();
        executorService.schedule(() -> {
            for (String topic : topics) {
                String tempmessage = GameMessage.MARATHON_CONNECTED.toJson();
                String message = topic + "에 연결되었습니다";
                marathonRoomManager.getMessagingTemplate().convertAndSend(topic, tempmessage);
            }
        }, 1, TimeUnit.SECONDS);

        executorService.shutdown();
    }


}
