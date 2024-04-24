package org.api.wadada.single.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.single.dto.req.SingleStartReq;
import org.api.wadada.single.dto.res.MainRes;
import org.api.wadada.single.entity.Member;
import org.api.wadada.single.entity.SingleRecord;
import org.api.wadada.single.exception.NotFoundMainResException;
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
    public int saveStartSingle(SingleStartReq singleStartReq) throws ParseException {
        Optional<Member> optional = memberRepository.findById(singleStartReq.getMemberSeq());
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
}
