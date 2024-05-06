package org.api.wadada.multi.service;

import lombok.AllArgsConstructor;
import org.api.wadada.multi.dto.req.GameEndReq;
import org.api.wadada.multi.dto.req.GameStartReq;
import org.api.wadada.multi.dto.res.GameEndRes;
import org.api.wadada.multi.dto.res.GameResultRes;
import org.api.wadada.multi.dto.res.GameStartRes;
import org.api.wadada.multi.entity.Member;
import org.api.wadada.multi.entity.MultiRecord;
import org.api.wadada.multi.repository.MemberRepository;
import org.api.wadada.multi.repository.MultiRecordRepository;
import org.locationtech.jts.io.ParseException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.Optional;

@Service
@AllArgsConstructor
public class MultiRecordServiceImpl implements MultiRecordService {
    private final MultiRecordRepository multiRecordRepository;
    private final MemberRepository memberRepository;

    public GameStartRes saveStartMulti(Principal principal, GameStartReq gameStartReq){
        // 멤버 조회
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        if(optional.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }

//        PointToStringConverter converter = new PointToStringConverter();
//        Point startLocationPoint = converter.convertToEntityAttribute(gameStartReq.getRecordStartLocation());

        MultiRecord multiRecord = MultiRecord.builder().multiRecordStart(gameStartReq.getRecordStartLocation())
                .memberSeq(optional.get().getMemberSeq())
                .multiRecordPeople(gameStartReq.getRecordPeople()).build();

        multiRecordRepository.save(multiRecord);



        return new GameStartRes(multiRecord.getMultiRecordSeq());
    }

    public GameEndRes saveEndMulti(Principal principal, GameEndReq gameEndReq){
        // 멤버 조회
        Optional<Member> optionalMember = memberRepository.getMemberByMemberId(principal.getName());
        if(optionalMember.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }

        Optional<MultiRecord> optional = multiRecordRepository.findByMemberId(optionalMember.get().getMemberSeq());
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
        ,multiRecord.getMultiRecordDist(),multiRecord.getMultiRecordTime(),multiRecord.getMultiRecordStart(),multiRecord.getMultiRecordEnd(),
                multiRecord.getMultiRecordSpeed(),multiRecord.getMultiRecordHeartbeat(),multiRecord.getMultiRecordMeanSpeed(),multiRecord.getMultiRecordMeanPace()
        ,multiRecord.getMultiRecordMeanHeartbeat());
    }
}
