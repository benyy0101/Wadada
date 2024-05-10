package org.api.wadada.multi.service;

import org.api.wadada.multi.dto.GameRoomDto;
import org.api.wadada.multi.dto.GameRoomManager;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.math3.optim.MaxEval;
import org.apache.commons.math3.optim.PointValuePair;
import org.apache.commons.math3.optim.nonlinear.scalar.GoalType;
import org.apache.commons.math3.optim.nonlinear.scalar.ObjectiveFunction;
import org.apache.commons.math3.optim.nonlinear.scalar.noderiv.NelderMeadSimplex;
import org.apache.commons.math3.optim.nonlinear.scalar.noderiv.SimplexOptimizer;
import org.api.wadada.multi.dto.LatLng;
import org.api.wadada.multi.dto.RoomDto;
import org.api.wadada.multi.dto.RoomManager;
import org.api.wadada.multi.dto.game.GameMessage;
import org.api.wadada.multi.dto.game.PlayerInfo;
import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.dto.req.UserPointReq;
import org.api.wadada.multi.dto.res.*;
import org.api.wadada.multi.dto.res.RoomMemberRes;
import org.api.wadada.multi.dto.res.RoomRes;
import org.api.wadada.multi.dto.res.PostRoomRes;
import org.api.wadada.multi.entity.Member;
import org.api.wadada.multi.entity.Room;
import org.api.wadada.multi.entity.RoomDocument;
import org.api.wadada.multi.exception.CanNotJoinRoomException;
import org.api.wadada.multi.exception.CreateRoomException;
import org.api.wadada.multi.exception.NotFoundMemberException;
import org.api.wadada.multi.exception.NotFoundRoomException;
import org.api.wadada.multi.repository.*;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.*;
import java.util.concurrent.*;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class RoomServiceImpl implements RoomService {
    private final RoomRepository roomRepository;
    private final MemberRepository memberRepository;
    private final HashTagElasticsearchRepository elasticsearchRepository;
    private final RoomDocumentRepository roomDocumentRepository;
    private final CustomRoomRepository customRoomRepository;
    private final RoomManager roomManager;
    private final GameRoomManager gameRoomManager;


    private final ConcurrentHashMap<Integer, CompletableFuture<Void>> gameStartFutures = new ConcurrentHashMap<>();
    private final SimpMessagingTemplate messagingTemplate;
    private ExecutorService executor = Executors.newCachedThreadPool();

    //

    private final ConcurrentHashMap<Integer, CompletableFuture<Void>> flagFutures = new ConcurrentHashMap<>();

    @Override
    public PostRoomRes createRoom(CreateRoomReq createRoomReq, Principal principal) throws Exception {
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        if (optional.isEmpty()) {
            throw new NotFoundMemberException();
        }
        Member member = optional.get();

        Optional<Integer> optionalIndex = roomManager.getEmptyIndex();
        if (optionalIndex.isEmpty()) {
            // 방 못 만들어요
            throw new CreateRoomException();
        }
        String roomTitle = "WADADA" + optionalIndex.get();
        Room room = Room.builder()
                .roomDist(createRoomReq.getRoomDist())
                .roomTime(createRoomReq.getRoomTime())
                .roomMode(createRoomReq.getRoomMode())
                .roomTag(createRoomReq.getRoomTag())
                .roomSecret(createRoomReq.getRoomSecret())
                .roomPeople(createRoomReq.getRoomPeople())
                .roomTitle(roomTitle)
                .roomMaker(member.getMemberSeq())
                .build();


        Room savedRoom = roomRepository.save(room);

        RoomDocument document = RoomDocument.builder()
                .roomSeq(savedRoom.getRoomSeq())
                .roomDist(savedRoom.getRoomDist())
                .roomTime(savedRoom.getRoomTime())
                .roomMode((byte) savedRoom.getRoomMode())
                .roomTag(savedRoom.getRoomTag())
                .roomSecret(savedRoom.getRoomSecret())
                .roomPeople((byte) savedRoom.getRoomPeople())
                .roomTitle(savedRoom.getRoomTitle())
                .roomMaker(savedRoom.getRoomMaker())
                .isDeleted(false)
                .updatedAt(new Date())
                .build();

        roomDocumentRepository.save(document);
        RoomDto roomDto = new RoomDto();
        roomDto.setRoomSeq(savedRoom.getRoomSeq());
        roomDto.setRoomMode(createRoomReq.getRoomMode());
        int idx = roomManager.addRoom(savedRoom.getRoomSeq(), roomDto);
        return PostRoomRes.builder().roomIdx(idx).roomSeq(savedRoom.getRoomSeq()).build();
    }

    @Override
    public HashMap<Integer, List<RoomMemberRes>> attendRoom(int roomIdx, Principal principal) {
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        Member member;
        if (optional.isEmpty()) {
            throw new NotFoundMemberException();
        }
        member = optional.get();

        // index에 맞는방 찾고
        RoomDto roomDto = roomManager.getAllRooms().get(roomIdx);
        int roomSeq = roomDto.getRoomSeq();
        Optional<Room> room = roomRepository.findById(roomSeq);
        if (room.isEmpty()) {
            throw new NotFoundRoomException("참가할 방이 없습니다");
        }
        // 방이 꽉찬 경우
        if (room.get().getRoomPeople() == roomDto.getMemberList().size()) {
            throw new CanNotJoinRoomException("방이 가득 찼습니다");
        }

        // 해당 방에 참가시키고
        if(roomDto.getMembers().isEmpty()){
            roomDto.addMember(RoomMemberRes.of(true, member));
        }
        else{
            roomDto.addMember(RoomMemberRes.of(false, member));
        }
        List<RoomMemberRes> memberResList = roomDto.getMemberList();
        // 해당 방 유저 정보들 반환
        HashMap<Integer, List<RoomMemberRes>> resultMap = new HashMap<>();
        resultMap.put(roomIdx, memberResList);
        return resultMap;
    }

    @Override
    public HashMap<Integer, List<RoomMemberRes>> leaveRoom(int roomIdx, Principal principal) {
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        Member member;
        if (optional.isEmpty()) {
            throw new NotFoundMemberException();
        }
        member = optional.get();

        // index에 맞는방 찾고
        RoomDto roomDto = roomManager.getAllRooms().get(roomIdx);
        // 해당 방에 멤버 삭제시키고
        boolean isManager = roomDto.removeMember(member.getMemberId());

        //방장이면 방 터트리기
        if (isManager) {
            // 해당 방 멤버 삭제하고 비우기
            roomManager.removeRoom(roomIdx);
            // db에 삭제 요청 날리기
            int roomSeq = roomDto.getRoomSeq();
            Optional<Room> room = roomRepository.findById(roomSeq);
            room.ifPresent(r -> {
                r.deleteSoftly();
                roomRepository.save(r);
            });
            HashMap<Integer, List<RoomMemberRes>> resultMap = new HashMap<>();
            resultMap.put(roomIdx, new ArrayList<>());
            return resultMap;
        }

        List<RoomMemberRes> memberResList = roomDto.getMemberList();
        // 해당 방 유저 정보들 반환
        HashMap<Integer, List<RoomMemberRes>> resultMap = new HashMap<>();
        resultMap.put(roomIdx, memberResList);
        return resultMap;
    }

    @Override
    public HashMap<Integer, List<RoomMemberRes>> changeReady(int roomIdx, Principal principal) {
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        Member member;
        if (optional.isEmpty()) {
            throw new NotFoundMemberException();
        }
        member = optional.get();

        // index에 맞는방 찾고
        RoomDto roomDto = roomManager.getAllRooms().get(roomIdx);
        // 해당 방에 멤버 삭제시키고
        roomDto.changeReady(member.getMemberId());

        List<RoomMemberRes> memberResList = roomDto.getMemberList();
        // 해당 방 유저 정보들 반환
        HashMap<Integer, List<RoomMemberRes>> resultMap = new HashMap<>();
        resultMap.put(roomIdx, memberResList);
        return resultMap;

    }

    // 모드별 방 검색
    @Override
    public List<RoomRes> getRoomList(int mode) {
        Map<Integer, RoomDto> activeRooms = roomManager.getAllRooms();
        List<Integer> activeSeqList = activeRooms.values().stream().filter(roomDto -> roomDto.getRoomMode() == mode).map(
                RoomDto::getRoomSeq).toList();

        HashMap<Integer, Integer> roomIdxMap = new HashMap<>();
        for (RoomDto roomDto : activeRooms.values()) {
            roomIdxMap.put(roomDto.getRoomSeq(), roomDto.getRoomIdx());
        }

        List<RoomRes> roomResList = roomRepository.findAllById(activeSeqList).stream().map(
                room -> {
                    int idx = roomIdxMap.get(room.getRoomSeq());
                    int now = activeRooms.get(idx).getMembers().size();
                    return RoomRes.of(idx, room, now);
                }
        ).toList();
        log.info("같은 방 찾기");
        return roomResList;
    }

    // 해시태그 방 검색
    @Override
    public List<RoomRes> findByRoomTag(String roomTag) throws Exception {
        String[] tagList = roomTag.split(" ");

        // 레포지토리에서 검색
        List<RoomDocument> roomDocuments = customRoomRepository.findByRoomTags(tagList);
        for (RoomDocument document : roomDocuments) {
            log.info(document.getRoomTag());
        }
        // 현재 활성화된 룸 정보 가져오고
        HashMap<Integer, Integer> roomInfo = new HashMap<>();
        Map<Integer,RoomDto> activeRooms = roomManager.getAllRooms();
        for (Map.Entry<Integer, RoomDto> room : activeRooms.entrySet()) {
            roomInfo.put(room.getValue().getRoomSeq(), room.getValue().getRoomIdx());
        }


        //거르는 작업(로그 스태시가 1분 주기라 삭제 반영 안된 정보 거르기)
        roomDocuments = roomDocuments.stream()
                .filter(roomDocument -> activeRooms.values().stream()
                        .anyMatch(r -> r.getRoomSeq() == roomDocument.getRoomSeq()))
                .toList();


        // index와 정보를 response로
        List<RoomRes> roomResList = roomDocuments.stream().map(
                roomDocument -> {
                    int idx = roomInfo.get(roomDocument.getRoomSeq());
                    int now = activeRooms.get(idx).getMembers().size();
                    return RoomRes.of(roomInfo.get(roomDocument.getRoomSeq()), roomDocument,now);
                }
        ).collect(Collectors.toList());

        return roomResList;
    }

    public void getFlagPoint(int roomIdx) {

        RoomDto roomDto = roomManager.getAllRooms().get(roomIdx);

        CompletableFuture<Void> flagOptimization = CompletableFuture.anyOf(
                CompletableFuture.runAsync(() -> awaitAllMemberSend(roomDto), executor),
                CompletableFuture.runAsync(this::waitSeconds, executor)
        ).thenRun(() -> {  //하나라도 성공하면
            FlagPointRes message = calculatePoint(roomDto.getRoomPoints());
            messagingTemplate.convertAndSend("/sub/attend/" + roomIdx, message);
            roomDto.getRoomPoints().clear();
        });

        flagFutures.put(roomIdx, flagOptimization);
    }

    // 게임시작
    //멤버 다 보낼 때 까지
    private void awaitAllMemberSend(RoomDto roomDto) {
        synchronized (roomDto.getRoomPoints()) {
            while (roomDto.getRoomPoints().size() < roomDto.getMembers().size()) {
                try {
                    roomDto.getRoomPoints().wait();
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    return;
                }
            }
        }
    }

    private void waitSeconds() {
        try {
            TimeUnit.SECONDS.sleep(7);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }


    public void removeRoom(int roomSeq, int roomIdx) {
        roomManager.removeRoom(roomIdx);
        Optional<Room> room = roomRepository.findById(roomSeq);
        room.ifPresent(r -> {
            r.deleteSoftly();
            roomRepository.save(r);
        });
    }


    public void startGame(int roomIdx) {
        RoomDto curRoom = roomManager.getAllRooms().get(roomIdx);
        ConcurrentMap<String, PlayerInfo> infoConcurrentMap = new ConcurrentHashMap<>();
        HashMap<String,Boolean> disconnected = new HashMap<>();
        HashMap<String,Boolean> finished = new HashMap<>();

        for(RoomMemberRes member :curRoom.getMembers().values()){
            PlayerInfo playerInfo = PlayerInfo.builder()
                    .isManager(member.isManager())
                    .name(member.getMemberNickname())
                    .profileImage(member.getMemberProfileImage())
                    .memberId(member.getMemberId())
                    .build();
            infoConcurrentMap.put(member.getMemberId(),playerInfo);
            disconnected.put(member.getMemberId(),false);
            finished.put(member.getMemberId(),false);
        }


        GameRoomDto curGame = GameRoomDto.builder()
                .roomIdx(roomIdx)
                .curPeople(0)
                .MaxPeople(curRoom.getMemberCount())
                .playerInfo(infoConcurrentMap)
                .disconnected(disconnected)
                .finished(finished)
                .roomSeq(curRoom.getRoomSeq()).build();
        removeRoom(curRoom.getRoomSeq(), curRoom.getRoomIdx());
        //연결 끊었다가 새로하는 로직

        try {
            gameRoomManager.addRoom(curRoom.getRoomSeq(), curGame);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        CompletableFuture<Void> tasks = CompletableFuture.anyOf(
                //모든사람이 들어왔으면 시작
                CompletableFuture.runAsync(() -> {
                    synchronized (curGame) {
                        while (curGame.getCurPeople() < curGame.getMaxPeople()) {
                            try {
                                curGame.wait();
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
            sendMessage(curGame);
        });
        gameStartFutures.put(curGame.getRoomSeq(),tasks);
    }
    private void sendMessage (GameRoomDto curGame){
        String message = GameMessage.GAME_START.toJson();
        System.out.println(message + " " + curGame.getRoomIdx());
        messagingTemplate.convertAndSend("/sub/attend/" + curGame.getRoomIdx(), message);
    }



    //유저의 위치 정보를 저장(flag 할 때)
    public void saveUserPoint(UserPointReq userPointReq){
        // 방을 찾고
        RoomDto roomDto = roomManager.getAllRooms().get(userPointReq.getRoomIdx());
        if(roomDto == null){
            throw new RuntimeException("좌표 저장 중 index에 맞는 방을 못찾았습니다.");
        }
        // 방 point에 추가하기
        synchronized (roomDto.getRoomPoints()) {
            roomDto.addPoint(userPointReq.getLatitude(), userPointReq.getLongitude());
            if (roomDto.getRoomPoints().size() == roomDto.getMembers().size()) {
                roomDto.getRoomPoints().notifyAll();
            }
        }

        for(LatLng e:roomDto.getRoomPoints()){
            log.info(e.toString());
        }
    }

    // 최적값 계산
    public FlagPointRes calculatePoint(List<LatLng> points){

        double sumX = 0, sumY = 0;
        for (LatLng p : points) {
            sumX += p.getX();
            sumY += p.getY();
        }
        LatLng startPoint = new LatLng(sumX / points.size(), sumY / points.size());

        SimplexOptimizer optimizer = new SimplexOptimizer(1e-10, 1e-10);
        NelderMeadSimplex simplex = new NelderMeadSimplex(new double[] {0.01, 0.01});

        ObjectiveFunction objFunction = new ObjectiveFunction(point -> {
            double variance = 0;
            double meanDistance = 0;
            List<Double> distances = new ArrayList<>();

            for (LatLng p : points) {
                double dist = startPoint.distanceTo(p);
                distances.add(dist);
                meanDistance += dist;
            }
            meanDistance /= points.size();

            for (double dist : distances) {
                variance += Math.pow(dist - meanDistance, 2);
            }
            variance /= points.size();

            return variance;
        });

        PointValuePair result = optimizer.optimize(
                new MaxEval(10000),
                objFunction,
                GoalType.MINIMIZE,
                simplex,
                new org.apache.commons.math3.optim.InitialGuess(new double[]{startPoint.getX(), startPoint.getY()})
        );

        return FlagPointRes.builder().latitude(result.getPoint()[0]).longitude(result.getPoint()[1]).build();
    }



}
