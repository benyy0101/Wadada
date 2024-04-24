package org.api.wadada.single.service;

import lombok.RequiredArgsConstructor;
import org.api.wadada.single.dto.res.MainRes;
import org.api.wadada.single.entity.SingleRecord;
import org.api.wadada.single.repository.SingleRecordRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SingleRecordServiceImpl implements SingleRecordService {

    private final SingleRecordRepository singleRecordRepository;
    @Override
    public MainRes getSingleMain(Member member) {
        List<SingleRecord> singleRecords = singleRecordRepository.getSingleRecordByMemberSeq(member.getMemberSeq);
        double meanSpeed = 0.0;
        double meanPace = 0.0;
        double meanBeat = 0.0;

        //SingleRecord들의 평균 합 더하고 나누기
        singleRecords.stre

        MainRes mainRes = MainRes.builder()
                .dist(member.getMemberTotalDist)
                .recordTime(member.getMemberTotalTime)
                .speed()
                .recordPace()
                .recordHeartbeat()
                .build();

    }
}
