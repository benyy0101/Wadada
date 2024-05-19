package org.api.wadada.app.mypage.service;

import lombok.AllArgsConstructor;
import org.api.wadada.app.mypage.controller.dto.*;
import org.api.wadada.app.mypage.repository.MyPageRepositoryImpl;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Service
@AllArgsConstructor
public class MyPageService {
    private final MyPageRepositoryImpl myPageRepository;

    public RecordListDto getRecord(Integer memberSeq, LocalDateTime startDateTime, LocalDateTime endDateTime){
        return myPageRepository.getRecord(memberSeq,startDateTime,endDateTime);
    }
    public SingleRecordDto getSingleRecord(Integer memberSeq, Integer recordSeq){
        //싱글
        return myPageRepository.getSingleRecord(memberSeq,recordSeq);
    }
    public MultiRecordDto getMultiRecord(Integer memberSeq, Integer recordSeq){
        //멀티
        return myPageRepository.getMultiRecord(memberSeq,recordSeq);
    }
    public MarathonRecordDto getMarathonRecord(Integer memberSeq, Integer recordSeq){
        //마라톤
        return myPageRepository.getMarathonRecord(memberSeq,recordSeq);
    }
}
