package org.api.wadada.single.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.single.dto.res.MainRes;
import org.api.wadada.single.service.SingleRecordService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/Single")
@Slf4j
public class SingleRecordController {

    private final SingleRecordService singleRecordService;

    @GetMapping
    public ResponseEntity<MainRes> SingleMain(@AuthenticationPrincipal Member member){

        return new ResponseEntity<>(singleRecordService.getSingleMain(member), HttpStatus.OK);

    }

}
