package org.api.wadada.marathon.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.errorcode.ErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.api.wadada.marathon.dto.MarathonRoomDto;
import org.api.wadada.marathon.dto.MarathonRoomManager;
import org.api.wadada.marathon.dto.MemberInfo;
import org.api.wadada.marathon.dto.req.MarathonCreateReq;
import org.api.wadada.marathon.dto.req.MarathonGameEndReq;
import org.api.wadada.marathon.dto.req.MarathonGameStartReq;
import org.api.wadada.marathon.dto.res.*;
import org.api.wadada.marathon.entity.Marathon;
import org.api.wadada.marathon.entity.MarathonRecord;
import org.api.wadada.marathon.entity.Member;
import org.api.wadada.marathon.exception.NotFoundMemberException;
import org.api.wadada.marathon.repository.MarathonRecordRepository;
import org.api.wadada.marathon.repository.MemberRepository;
import org.api.wadada.marathon.repository.MarathonRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
public class MarathonServiceImpl implements MarathonService {

    private final MarathonRepository marathonRepository;
    private final MarathonRecordRepository marathonRecordRepository;
    private final MarathonRoomManager marathonRoomManager;
    private final MemberRepository memberRepository;
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
                marathonRoomManager.addRoom(new MarathonRoomDto(freshmarathon.getMarathonSeq()));

            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            return freshmarathon.getMarathonSeq();
        }
        throw new SecurityException();
    }

    @Override
    public boolean isMarathonReady(Principal principal,int marathonSeq) {
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        if (optional.isEmpty()) {
            throw new NotFoundMemberException();
        }
        Member member = optional.get();

        MemberInfo memberInfo = MemberInfo.builder().MemberSeq(member.getMemberSeq())
                .MemberName(member.getMemberNickName())
                .registTime(LocalDateTime.now()).build();

        MarathonRoomDto curMarathon = marathonRoomManager.getAllRooms().get(marathonSeq);

        System.out.println("marathonSeq = " + marathonSeq);
        System.out.println(curMarathon);
        System.out.println(memberInfo.toString());


        if(curMarathon.insertMember(memberInfo)){
            return true;
        }
        return false;
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
                    .marathonRecordIsWin(marathonGameStartReq.isMarathonRecordIsWin())
                    .marathonRecordStart(marathonGameStartReq.getMarathonRecordStart())
                    .marathonSeq(marathonGameStartReq.getMarathonSeq())
                    .member(member) // Member 인스턴스 설정
                    .build();

            MarathonRecord freshRecord = marathonRecordRepository.save(marathonRecord);
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
            marathonRoomManager.removeRoom(RoomSeq);
            return true;
        } catch (RestApiException e) {
            throw new RestApiException(CustomErrorCode.NO_ROOM);
        }
    }

}
