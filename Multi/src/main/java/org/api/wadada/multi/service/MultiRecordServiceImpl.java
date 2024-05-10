package org.api.wadada.multi.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.multi.dto.GameRoomDto;
import org.api.wadada.multi.dto.GameRoomManager;
import org.api.wadada.multi.dto.RoomDto;
import org.api.wadada.multi.dto.RoomManager;
import org.api.wadada.multi.dto.game.PlayerInfo;
import org.api.wadada.multi.dto.req.GameEndReq;
import org.api.wadada.multi.dto.req.GameStartReq;
import org.api.wadada.multi.dto.req.RequestDataReq;
import org.api.wadada.multi.dto.res.*;
import org.api.wadada.multi.entity.Member;
import org.api.wadada.multi.entity.MultiRecord;
import org.api.wadada.multi.repository.MemberRepository;
import org.api.wadada.multi.repository.MultiRecordRepository;
import org.elasticsearch.monitor.os.OsStats;
import org.hibernate.annotations.Synchronize;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.io.ParseException;
import org.locationtech.jts.io.WKTReader;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.*;
import java.util.concurrent.*;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
@Slf4j
public class MultiRecordServiceImpl implements MultiRecordService {
    private final MultiRecordRepository multiRecordRepository;
    private final MemberRepository memberRepository;
    private final RoomManager roomManager;
    private final GameRoomManager gameRoomManager;
    private final SimpMessagingTemplate messagingTemplate;
    private ScheduledExecutorService scheduler;

    public GameStartRes saveStartMulti(Principal principal, GameStartReq gameStartReq) throws ParseException {
        // 멤버 조회
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        if(optional.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }

//        PointToStringConverter converter = new PointToStringConverter();
//        Point startLocationPoint = converter.convertToEntityAttribute(gameStartReq.getRecordStartLocation());
        WKTReader reader = new WKTReader();
        Point point = (Point) reader.read("POINT (1 1)");

        MultiRecord multiRecord = MultiRecord.builder().multiRecordStart(point)
                .memberSeq(optional.get().getMemberSeq())
                .roomSeq(gameStartReq.getRoomSeq())
                .multiRecordPeople(gameStartReq.getRecordPeople()).build();

        System.out.println("gameRoomManager.getAllRooms().size() = " + gameRoomManager.getAllRooms().values());
        GameRoomDto gameRoomDto = gameRoomManager.getAllRooms().get(gameStartReq.getRoomSeq());
        System.out.println("gameRoomDto = " + gameRoomDto.getRoomSeq());
        gameRoomDto.increasedMember();



        multiRecordRepository.save(multiRecord);



        return new GameStartRes(multiRecord.getMultiRecordSeq());
    }

    public GameEndRes saveEndMulti(Principal principal, GameEndReq gameEndReq){
        // 멤버 조회
        Optional<Member> optionalMember = memberRepository.getMemberByMemberId(principal.getName());
        if(optionalMember.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }

        Optional<MultiRecord> optional = multiRecordRepository.findByMemberIdandRoomSeq(optionalMember.get().getMemberSeq(),gameEndReq.getRoomIdx());
        if(optional.isEmpty()){
            throw new NullPointerException("기록을 찾을 수 없습니다");
        }
        optional.get().updateEnd(gameEndReq.getRecordEndLocation(),gameEndReq.getRecordTime(),gameEndReq.getRecordDist(),
                gameEndReq.getRecordImage(),gameEndReq.getRecordRank(),gameEndReq.getRecordWay(),gameEndReq.getRecordPace(),
                gameEndReq.getRecordSpeed(),gameEndReq.getRecordHeartbeat());

//        PointToStringConverter converter = new PointToStringConverter();
//        Point startLocationPoint = converter.convertToEntityAttribute(gameEndReq.getRecordStartLocation());



        return new GameEndRes(optional.get().getMultiRecordSeq());
    }

    @Override
    public GameResultRes getResultMulti(Principal principal, Integer roomSeq) throws ParseException {
        // 멤버 조회
        Optional<Member> optionalMember = memberRepository.getMemberByMemberId(principal.getName());
        if(optionalMember.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }

        Optional<MultiRecord> optional = multiRecordRepository.findByMemberIdandRoomSeq(optionalMember.get().getMemberSeq(),roomSeq);
        if(optional.isEmpty()){
            throw new NullPointerException("기록을 찾을 수 없습니다");
        }

        MultiRecord multiRecord = optional.get();

        return new GameResultRes(multiRecord.getMultiRecordRank(),multiRecord.getMultiRecordPace(),multiRecord.getMultiRecordImage()
        ,multiRecord.getMultiRecordDist(),multiRecord.getMultiRecordTime(),multiRecord.getMultiRecordStart().toString(),multiRecord.getMultiRecordEnd().toString(),
                multiRecord.getMultiRecordSpeed(),multiRecord.getMultiRecordHeartbeat(),multiRecord.getMultiRecordMeanSpeed(),multiRecord.getMultiRecordMeanPace()
        ,multiRecord.getMultiRecordMeanHeartbeat());
    }

    @Override
    public void savePlayerData(Principal principal, RequestDataReq requestDataReq) {
        Optional<Member> optionalMember = memberRepository.getMemberByMemberId(principal.getName());
        if(optionalMember.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }
        Member member = optionalMember.get();
        GameRoomDto gameRoomDto = gameRoomManager.getAllRooms().get(requestDataReq.getRoomSeq());
        ConcurrentMap<String, PlayerInfo> infoConcurrentMap = gameRoomDto.getPlayerInfo();
        if(infoConcurrentMap.containsKey(member.getMemberId())){
            gameRoomDto.updatePlayerInfo(member.getMemberId(),requestDataReq.getUserDist(), requestDataReq.getUserTime());
        }
        else{
            throw new NullPointerException("멤버의 기록을 게임방에 넣지 못했습니다");
        }
    }

    // 멤버들에게 현재 등수 뿌려주기
    @Override
    public void getPlayerRank(int roomSeq) {

        scheduler.scheduleAtFixedRate(() -> {
            String message = "{\"message\": \"멤버INFO요청\", \"action\": \"/Multi/game/data\"}";
            messagingTemplate.convertAndSend("/sub/game/" + roomSeq, message);
            try {
                Thread.sleep(10000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            try {
                log.info(String.valueOf(roomSeq));

                // 게임 방 정보 가져오기
                GameRoomDto roomDto = gameRoomManager.getAllRooms().get(roomSeq);
                List<GameInfoRes> gameInfoRes = new ArrayList<>();
                List<PlayerInfo> playerInfos = new ArrayList<>(roomDto.getPlayerInfo().values());
                Collections.sort(playerInfos);
                HashMap<String, Integer> rank = new HashMap<>();
                for (int i = 0; i < playerInfos.size(); i++) {
                    rank.put(playerInfos.get(i).getMemberId(), i + 1);
                }
                for (PlayerInfo playerInfo : playerInfos) {
                    gameInfoRes.add(GameInfoRes.builder()
                            .memberRank(rank.get(playerInfo.getMemberId()))
                            .memberNickname(playerInfo.getName())
                            .memberProfile(playerInfo.getProfileImage())
                            .memberDist(playerInfo.getDist())
                            .memberTime(playerInfo.getTime())
                            .build());
                }
                messagingTemplate.convertAndSend("/sub/game/" + roomSeq, gameInfoRes);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, 0, 10, TimeUnit.SECONDS);


    }

    public void stopPlayerRankUpdates() {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
            try {
                if (!scheduler.awaitTermination(1, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                    log.info("스케줄 종료가 성공하였습니다.");
                }
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
                log.info("스케줄 종료가 실패하였습니다.");
            }
        }
    }


}
