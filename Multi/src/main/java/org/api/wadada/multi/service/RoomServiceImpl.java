package org.api.wadada.multi.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.multi.dto.RoomDto;
import org.api.wadada.multi.dto.RoomManager;
import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.dto.res.AttendRoomRes;
import org.api.wadada.multi.dto.res.LeaveRoomRes;
import org.api.wadada.multi.dto.res.RoomMemberRes;
import org.api.wadada.multi.entity.Member;
import org.api.wadada.multi.entity.Room;
import org.api.wadada.multi.exception.CreateRoomException;
import org.api.wadada.multi.exception.NotFoundMemberException;
import org.api.wadada.multi.repository.MemberRepository;
import org.api.wadada.multi.repository.RoomRepository;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class RoomServiceImpl implements RoomService{

    private final RoomRepository roomRepository;
    private final MemberRepository memberRepository;
    private final RoomManager roomManager = new RoomManager();

    @Override
    public HashMap<Integer, List<RoomMemberRes>> createRoom(CreateRoomReq createRoomReq, Principal principal) throws Exception {
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        if(optional.isEmpty()){
            throw new NotFoundMemberException();
        }
        Member member = optional.get();

        Optional<Integer> optionalIndex = roomManager.getEmptyIndex();
        if(optionalIndex.isEmpty()){
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
        RoomDto roomDto = new RoomDto();
        roomDto.addMember(RoomMemberRes.of(true,member));
        List<RoomMemberRes> memberResList = roomDto.getMemberList();

        int idx = roomManager.addRoom(savedRoom.getRoomSeq(),roomDto);

        HashMap<Integer, List<RoomMemberRes>> resultMap = new HashMap<>();
        resultMap.put(idx, memberResList);
        return resultMap;
    }

    @Override
    public HashMap<Integer, List<RoomMemberRes>> attendRoom(int roomIdx,Principal principal) {
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        Member member;
        if(optional.isEmpty()) {
            throw new NotFoundMemberException();
        }
        member = optional.get();

        // index에 맞는방 찾고
        RoomDto roomDto = roomManager.getAllRooms().get(roomIdx);
        // 해당 방에 참가시키고
        roomDto.addMember(RoomMemberRes.of(false,member));
        List<RoomMemberRes> memberResList = roomDto.getMemberList();
        // 해당 방 유저 정보들 반환
        HashMap<Integer, List<RoomMemberRes>> resultMap = new HashMap<>();
        resultMap.put(roomIdx, memberResList);
        return resultMap;
    }

    @Override
    public HashMap<Integer, List<RoomMemberRes>> leaveRoom(int roomIdx,Principal principal) {
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        Member member;
        if(optional.isEmpty()) {
            throw new NotFoundMemberException();
        }
        member = optional.get();

        // index에 맞는방 찾고
        RoomDto roomDto = roomManager.getAllRooms().get(roomIdx);
        // 해당 방에 멤버 삭제시키고
        roomDto.removeMember(member.getMemberId());

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
        if(optional.isEmpty()) {
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
}
// 방 타이틀,