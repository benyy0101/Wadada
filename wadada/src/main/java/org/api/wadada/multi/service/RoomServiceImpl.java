package org.api.wadada.multi.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.dto.res.AttendRoomRes;
import org.api.wadada.multi.entity.Member;
import org.api.wadada.multi.entity.Room;
import org.api.wadada.multi.exception.NotFoundMemberException;
import org.api.wadada.multi.repository.MemberRepository;
import org.api.wadada.multi.repository.RoomRepository;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class RoomServiceImpl implements RoomService{

    private final RoomRepository roomRepository;
    private final MemberRepository memberRepository;
    @Override
    public void createRoom(CreateRoomReq createRoomReq, Principal principal) {
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        if(optional.isEmpty()){
            throw new NotFoundMemberException();
        }
        Member member = optional.get();
        Room room = Room.builder()
                .roomDist(createRoomReq.getRoomDist())
                .roomTime(createRoomReq.getRoomTime())
                .roomMode(createRoomReq.getRoomMode())
                .roomTag(createRoomReq.getRoomTag())
                .roomSecret(createRoomReq.getRoomSecret())
                .roomPeople(createRoomReq.getRoomPeople())
                .roomTitle(createRoomReq.getRoomTitle())
                .roomMaker(member.getMemberSeq())
                .build();

        roomRepository.save(room);
    }

    @Override
    public AttendRoomRes attendRoom(Principal principal) {
        log.info(principal.getName());
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        Member member;
        if(optional.isEmpty()) {
            throw new NotFoundMemberException();
        }
        member = optional.get();
        return AttendRoomRes.builder()
                .memberGender(member.getMemberGender())
                .memberLevel(member.getMemberLevel())
                .memberProfileImage(member.getMemberProfileImage())
                .memberNickname(member.getMemberNickName())
                .build();
    }
}
