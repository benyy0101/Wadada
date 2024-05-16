package org.api.wadada.multi.service;

import jakarta.json.Json;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.multi.dto.GameRoomDto;
import org.api.wadada.multi.dto.GameRoomManager;
import org.api.wadada.multi.dto.RoomDto;
import org.api.wadada.multi.dto.RoomManager;
import org.api.wadada.multi.dto.game.GameMessage;
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
@RequiredArgsConstructor
@Slf4j
public class MultiRecordServiceImpl implements MultiRecordService {
    private final MultiRecordRepository multiRecordRepository;
    private final MemberRepository memberRepository;
    private final RoomManager roomManager;
    private final GameRoomManager gameRoomManager;
    private final SimpMessagingTemplate messagingTemplate;
    private Map<Integer, ScheduledExecutorService> roomSchedulers = new ConcurrentHashMap<>();
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
        roomSchedulers.computeIfAbsent(roomSeq, k -> Executors.newScheduledThreadPool(1))
                .scheduleAtFixedRate(() -> updatePlayRank(roomSeq), 0, 6, TimeUnit.SECONDS);
    }

    public void updatePlayRank(int roomSeq){
        ObjectMapper mapper = new ObjectMapper();
        // 게임 방 정보 가져오기
        GameRoomDto roomDto = gameRoomManager.getAllRooms().get(roomSeq);
        List<PlayerInfo> playerInfos = new ArrayList<>(roomDto.getPlayerInfo().values());
        // 서버에서 완주한 사람
//        for(PlayerInfo playerInfo: playerInfos){
//            int dist = playerInfo.getDist();
//            if(dist)
//        }

        //끊어진 사람 수 세기
        int cnt = 0;
        for(PlayerInfo playerInfo: playerInfos){
            if(!roomDto.getDisconnected(playerInfo.getMemberId())){
                cnt++;
            }
        }
        log.info("끊어진 사람 수 count@@@@@@@@        "+cnt);
        // 다 끊어진 경우 게임 종료
        if(cnt == roomDto.getCurPeople()){
            stopPlayerRankUpdates(roomSeq);
        }

        String message = GameMessage.GAME_LIVE_INFO_REQUEST.toJson();
        messagingTemplate.convertAndSend("/sub/game/" + roomSeq, message);

        try {
            List<GameInfoRes> gameInfoRes = new ArrayList<>();
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

            HashMap<String, Object> responseBody = new HashMap<>();
//            responseBody.put("message", "멤버순위");
            responseBody.put("memberInfo", gameInfoRes);

            HashMap<String, Object> responseHeader = new HashMap<>();
            responseHeader.put("status", 200);
            responseHeader.put("statusText", "OK");

            HashMap<String, Object> fullMessage = new HashMap<>();
            fullMessage.put("header", responseHeader);
            fullMessage.put("body", responseBody);

            String fullMessageJson = mapper.writeValueAsString(fullMessage);
            messagingTemplate.convertAndSend("/sub/game/" + roomSeq, fullMessageJson);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // 종료 조건
    // (curConnection == MaxConnection) 자동 End API 호출  완주해도 늘어나고, 연결이 끊겨도 늘어남
    // || 누가 End API 호출
    public void stopPlayerRankUpdates(int roomSeq) {
        log.info(roomSeq+"게임이 종료되었습니다");
        //게임이 종료 되기 전 방 지우기
        gameRoomManager.removeRoom(roomSeq);
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

    //
}
