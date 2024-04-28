package org.api.wadada.app.mypage.service;

import lombok.AllArgsConstructor;
import org.api.wadada.app.mypage.controller.dto.RecordDto;
import org.api.wadada.app.mypage.controller.dto.RecordListDto;
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

}
