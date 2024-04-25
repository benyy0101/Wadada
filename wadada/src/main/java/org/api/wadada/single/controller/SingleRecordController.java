package org.api.wadada.single.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.single.dto.req.SingleEndReq;
import org.api.wadada.single.dto.req.SingleMainReq;
import org.api.wadada.single.dto.req.SingleStartReq;
import org.api.wadada.single.dto.res.MainRes;
import org.api.wadada.single.service.SingleRecordService;
import org.locationtech.jts.io.ParseException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
//import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/Single")
@Slf4j
public class SingleRecordController {

    private final SingleRecordService singleRecordService;

    @PostMapping
    public ResponseEntity<MainRes> SingleMain(@RequestBody SingleMainReq singleMainReq){
        return new ResponseEntity<>(singleRecordService.getSingleMain(singleMainReq.getMemberSeq()), HttpStatus.OK);
    }

    @PostMapping("/start")
    @Transactional
    public ResponseEntity<Integer> saveStartSingle(@RequestBody SingleStartReq singleStartReq) throws ParseException {
        int seq = singleRecordService.saveStartSingle(singleStartReq);
        return new ResponseEntity<>(seq,HttpStatus.OK);
    }

    @PostMapping("/result")
    @Transactional
    public ResponseEntity<Integer> saveEndSingle(@RequestBody SingleEndReq singleEndReq) throws ParseException {
        int seq = singleRecordService.saveEndSingle(singleEndReq);
        return new ResponseEntity<>(seq,HttpStatus.OK);
    }


}
