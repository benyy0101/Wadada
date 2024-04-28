package org.api.wadada.app.mypage.controller;


import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.api.wadada.app.mypage.controller.dto.RecordListDto;
import org.api.wadada.app.mypage.service.MyPageService;
import org.api.wadada.util.MemberUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;

@RestController
@RequestMapping("/record")
@AllArgsConstructor
public class MyPageController {
    private final MyPageService myPageService;
    @GetMapping("/{date}")
    public ResponseEntity<RecordListDto> getMonthlyRecords(@Valid @PathVariable("date") String date){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
        YearMonth yearMonth = YearMonth.parse(date, formatter);

        Integer memberSeq = MemberUtil.getMemberSeq();
        LocalDateTime startDateTime = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime endDateTime = yearMonth.atEndOfMonth().atTime(23, 59, 59);

        return ResponseEntity.ok(myPageService.getRecord(memberSeq,startDateTime,endDateTime));
    }

    @PostMapping("/single")
    public ResponseEntity<?> getSingleRecords(){

        return ResponseEntity.ok().build();
    }
    @PostMapping("/multi")
    public ResponseEntity<?> getMultiRecords(){

        return ResponseEntity.ok().build();
    }
    @PostMapping("/marathon")
    public ResponseEntity<?> getMarathonRecords(){

        return ResponseEntity.ok().build();
    }
}
