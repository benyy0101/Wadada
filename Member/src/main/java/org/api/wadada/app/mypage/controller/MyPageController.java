package org.api.wadada.app.mypage.controller;


import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.api.wadada.app.mypage.controller.dto.RecordListDto;
import org.api.wadada.app.mypage.service.MyPageService;
import org.api.wadada.image.S3UploadService;
import org.api.wadada.util.MemberUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;

@RestController
@RequestMapping("/record")
@AllArgsConstructor
public class MyPageController {
    private final MyPageService myPageService;
    private final S3UploadService s3UploadService;
    @GetMapping("/{date}")
    public ResponseEntity<RecordListDto> getMonthlyRecords(@Valid @PathVariable("date") String date){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
        YearMonth yearMonth = YearMonth.parse(date, formatter);

        Integer memberSeq = MemberUtil.getMemberSeq();
        LocalDateTime startDateTime = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime endDateTime = yearMonth.atEndOfMonth().atTime(23, 59, 59);

        return ResponseEntity.ok(myPageService.getRecord(memberSeq,startDateTime,endDateTime));
    }

    @GetMapping("/single/{record}")
    public ResponseEntity<?> getSingleRecords(@Valid @PathVariable("record") Integer SingleRecord ){
        Integer memberSeq = MemberUtil.getMemberSeq();
        return ResponseEntity.ok(myPageService.getSingleRecord(memberSeq,SingleRecord));
    }
    @GetMapping("/multi/{record}")
    public ResponseEntity<?> getMultiRecords(@Valid @PathVariable("record") Integer MultiRecord ){
        Integer memberSeq = MemberUtil.getMemberSeq();
        return ResponseEntity.ok(myPageService.getMultiRecord(memberSeq,MultiRecord));

    }
    @GetMapping("/marathon/{record}")
    public ResponseEntity<?> getMarathonRecords(@Valid @PathVariable("record") Integer MarathonRecord ){
        Integer memberSeq = MemberUtil.getMemberSeq();
        return ResponseEntity.ok(myPageService.getMarathonRecord(memberSeq,MarathonRecord));

    }
    @PostMapping("/image")
    public ResponseEntity<String> createProfileImage(@RequestPart MultipartFile profileImageFile) throws IOException {
        String uploadedImageUrl = s3UploadService.saveFile(profileImageFile, "profiles/");
        return ResponseEntity.ok(uploadedImageUrl);
    }



}
