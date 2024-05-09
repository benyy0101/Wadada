package org.api.wadada.multi.service;

import org.api.wadada.multi.dto.GameRoomDto;
import org.api.wadada.multi.dto.GameRoomManager;
import org.api.wadada.multi.dto.RoomDto;
import org.api.wadada.multi.dto.RoomManager;
import org.api.wadada.multi.dto.game.GameMessage;
import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.dto.res.CreateRoomRes;
import org.api.wadada.multi.dto.res.RoomMemberRes;
import org.api.wadada.multi.dto.res.RoomRes;
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
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.security.Principal;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
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
    @Override
    public int createRoom(CreateRoomReq createRoomReq, Principal principal) throws Exception {
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
        //roomDto.addMember(RoomMemberRes.of(true, member));
        List<RoomMemberRes> memberResList = roomDto.getMemberList();
        roomDto.setRoomSeq(savedRoom.getRoomSeq());
        roomDto.setRoomMode(createRoomReq.getRoomMode());
        int idx = roomManager.addRoom(savedRoom.getRoomSeq(), roomDto);

        HashMap<Integer, CreateRoomRes> resultMap = new HashMap<>();
        resultMap.put(idx, new CreateRoomRes(savedRoom.getRoomSeq(), memberResList));
//        return resultMap;
        return idx;
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
        if(roomDto.getMemberList().isEmpty()){
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
        Map<Integer, RoomDto> activeRooms = roomManager.getAllRooms();
        for (Map.Entry<Integer, RoomDto> room : activeRooms.entrySet()) {
            roomInfo.put(room.getValue().getRoomSeq(), room.getValue().getRoomIdx());
        }

        //거르는 작업(로그 스태시가 1분 주기라 삭제 반영 안된 정보 거르기)
        roomDocuments = roomDocuments.stream()
                .filter(roomDocument -> activeRooms.values().stream()
                        .anyMatch(room -> room.getRoomSeq() == roomDocument.getRoomSeq()))
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
        GameRoomDto curGame = GameRoomDto.builder()
                .roomIdx(roomIdx)
                .curPeople(0)
                .MaxPeople(curRoom.getMemberCount())
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
}

