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

import java.security.Principal;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
public class SingleRecordServiceImpl implements SingleRecordService {

    private final SingleRecordRepository singleRecordRepository;
    private final MemberRepository memberRepository;
    @Override
    public MainRes getSingleMain(Principal principal) {
        // 멤버ID로 최근 기록 조회
        Optional<MainRes> optional = singleRecordRepository.getSingleRecordByMemberId(principal.getName());
        if(optional.isPresent()){
            return optional.get();

        }
        else{
          throw new NotFoundMainResException();
        }

    }

    @Override
    public int saveStartSingle(Principal principal,SingleStartReq singleStartReq) throws ParseException {
        // 멤버 조회
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        if(optional.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }
        //Point 변환
        WKTReader reader = new WKTReader();
        Point point = (Point) reader.read(singleStartReq.getRecordStartLocation());
        //저장위한 엔티티 build
        SingleRecord singleRecord = SingleRecord.builder()
                .singleRecordStart(point)
                .singleRecordMode(singleStartReq.getRecordMode())
                .member(optional.get())
                .build();
        SingleRecord savedRecord = singleRecordRepository.save(singleRecord);
        return savedRecord.getSingleRecordSeq();
    }

    @Override
    public int saveEndSingle(Principal principal,SingleEndReq singleEndReq) throws ParseException {
        Optional<Member> optionalMember = memberRepository.getMemberByMemberId(principal.getName());
        if(optionalMember.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }
        // 시작 때 저장된 싱글기록 가져오기
        Optional<SingleRecord> optionalSingleRecord = singleRecordRepository.findById(singleEndReq.getSingleRecordSeq());
        SingleRecord singleRecord;

        if(optionalSingleRecord.isPresent()){
            singleRecord  = optionalSingleRecord.get();
            // 좌표 변환
            WKTReader reader = new WKTReader();
            Point startPoint = (Point) reader.read(singleEndReq.getRecordStartLocation());
            Point endPoint = (Point) reader.read(singleEndReq.getRecordEndLocation());

            System.out.println(singleEndReq);

            // 기존 레코드 업데이트
            singleRecord.updateEnd(
                    startPoint, endPoint, singleEndReq.getRecordTime(), singleEndReq.getRecordDist(),
                    singleEndReq.getRecordImage(), singleEndReq.getRecordWay(), singleEndReq.getRecordPace(), singleEndReq.getRecordMeanPace(),
                    singleEndReq.getRecordHeartbeat(), singleEndReq.getRecordMeanHeartbeat(), singleEndReq.getRecordSpeed(),
                    singleEndReq.getRecordMeanSpeed()
            );
            System.out.println(singleRecord.getSingleRecordHeartbeat());

            //새로 저장 후 seq 반환
            SingleRecord savedRecord = singleRecordRepository.save(singleRecord);
            return savedRecord.getSingleRecordSeq();
        }
        else{
            throw new NotFoundRecordException();
        }
    }
}
