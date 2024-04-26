package org.api.wadada.single.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.single.dto.req.SingleEndReq;
import org.api.wadada.single.dto.req.SingleStartReq;
import org.api.wadada.single.dto.res.MainRes;
import org.api.wadada.single.entity.Member;
import org.api.wadada.single.entity.SingleRecord;
import org.api.wadada.single.exception.NotFoundMainResException;
import org.api.wadada.single.exception.NotFoundRecordException;
import org.api.wadada.single.repository.MemberRepository;
import org.api.wadada.single.repository.SingleRecordRepository;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.io.ParseException;
import org.springframework.stereotype.Service;
import org.locationtech.jts.io.WKTReader;

import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
public class SingleRecordServiceImpl implements SingleRecordService {

    private final SingleRecordRepository singleRecordRepository;
    private final MemberRepository memberRepository;
    @Override
    public MainRes getSingleMain(int memberSeq) {
        Optional<MainRes> optional = singleRecordRepository.getSingleRecordByMemberSeq(memberSeq);
        if(optional.isPresent()){
            return optional.get();
        }
        else{
         throw new NotFoundMainResException();
        }

    }

    @Override
    public int saveStartSingle(Member member,SingleStartReq singleStartReq) throws ParseException {
        Optional<Member> optional = memberRepository.findById(member.getMemberSeq());
        if(optional.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }
        WKTReader reader = new WKTReader();
        Point point = (Point) reader.read(singleStartReq.getRecordStartLocation());
        SingleRecord singleRecord = SingleRecord.builder()
                .singleRecordStart(point)
                .member(optional.get())
                .build();
        SingleRecord savedRecord = singleRecordRepository.save(singleRecord);
        return savedRecord.getSingleRecordSeq();
    }

    @Override
    public int saveEndSingle(Member member,SingleEndReq singleEndReq) throws ParseException {
        Optional<Member> optionalMember = memberRepository.findById(member.getMemberSeq());
        if(optionalMember.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }

        Optional<SingleRecord> optionalSingleRecord = singleRecordRepository.findById(singleEndReq.getSingleRecordSeq());
        SingleRecord singleRecord;

        if(optionalSingleRecord.isPresent()){
            singleRecord  = optionalSingleRecord.get();
            // 좌표 변환
            WKTReader reader = new WKTReader();
            Point startPoint = (Point) reader.read(singleEndReq.getRecordStartLocation());
            Point endPoint = (Point) reader.read(singleEndReq.getRecordEndLocation());


            singleRecord.updateEnd(
                    startPoint, endPoint, singleEndReq.getRecordTime(), singleEndReq.getRecordDist(),
                    singleEndReq.getRecordImage(), singleEndReq.getRecordWay(), singleEndReq.getRecordPace(), singleEndReq.getRecordMeanPace(),
                    singleEndReq.getRecordHeartbeat(), singleEndReq.getRecordMeanHeartbeat(), singleEndReq.getRecordSpeed(),
                    singleEndReq.getRecordMeanSpeed()
            );
            SingleRecord savedRecord = singleRecordRepository.save(singleRecord);
        }
        else{
            throw new NotFoundRecordException();
        }
        return singleRecord.getSingleRecordSeq();
    }
}
