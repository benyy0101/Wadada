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
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.Principal;
import java.time.LocalDateTime;
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
            Marathon marathon = Marathon.builder().
                    marathonGoal(marathonCreateReq.getMarathonGoal()).
                    marathonStart(marathonCreateReq.getMarathonStart()).
                    marathonTitle(marathonCreateReq.getMarathonTitle()).marathonEnd(marathonCreateReq.getMarathonEnd())
                            .marathonText(marathonCreateReq.getMarathonText()).marathonParticipate(marathonCreateReq.getMarathonParticipate())
                            .marathonType(marathonCreateReq.getMarathonType())
                                    .marathonRound(marathonCreateReq.getMarathonRound()).build();
            Marathon freshmarathon = marathonRepository.save(marathon);
            try {
//                MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();
                //marathonRoomManager.addRoom(new MarathonRoomDto(freshmarathon.getMarathonSeq()));

                //추후 동시에 여러 마라톤 진행할 경우 해당 마라톤SEQ를 위와같이 넣어줘야 함
                marathonGameManager.CreateNewMarathonGame();
                MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();

                long delay = LocalDateTime.now().until(marathonCreateReq.getMarathonStart(), ChronoUnit.MILLIS);
                System.out.println("delay = " + delay);
                System.out.println("LocalDateTime.now() = " + LocalDateTime.now());
                scheduledExecutor.schedule(() -> {
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
                    ).thenRun(marathonRoomManager::sendMessage);

                }, delay, TimeUnit.MILLISECONDS);


            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            return freshmarathon.getMarathonSeq();
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
                .registTime(LocalDateTime.now()).build();

        //마라톤 SEQ에 해당하는 게임정보 확인
        MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();

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
            if(optional.isPresent()){
                throw new RestApiException(CustomErrorCode.DUPLICATE_RECORD);
            }


            MarathonRecord marathonRecord = MarathonRecord.builder()
                    .marathonRecordStart(marathonGameStartReq.getMarathonRecordStart())
                    .marathonSeq(marathonGameStartReq.getMarathonSeq())
                    .member(member) // Member 인스턴스 설정
                    .build();

            MarathonRecord freshRecord = marathonRecordRepository.save(marathonRecord);
            MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();

            marathonRoomManager.increaseRealCurPerson();


            return new MarathonGameStartRes(freshRecord.getMarathonRecordSeq());
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

            return new MarathonGameEndRes();
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
    public void stopPlayerRankUpdates(int roomSeq) {
        log.info(roomSeq+"게임이 종료되었습니다");
        //게임이 종료 되기 전 방 지우기
        marathonGameManager.CreateNewMarathonGame();
        ScheduledExecutorService scheduler = roomSchedulers.remove(roomSeq);
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

}
