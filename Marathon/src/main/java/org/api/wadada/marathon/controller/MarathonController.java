package org.api.wadada.marathon.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.marathon.dto.req.MarathonCreateReq;
import org.api.wadada.marathon.dto.req.MarathonGameEndReq;
import org.api.wadada.marathon.dto.req.MarathonGameStartReq;
import org.api.wadada.marathon.dto.res.*;
import org.api.wadada.marathon.service.MarathonService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
//import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.text.ParseException;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/Marathon")
@Slf4j
public class MarathonController {

    private final MarathonService marathonService;

    @GetMapping
    public ResponseEntity<List<MainRes>> MarathonMain(){
        return ResponseEntity.ok(marathonService.getMarathonMain());
    }

    @GetMapping("/participate/{marathon_seq}")
    public ResponseEntity<List<MarathonMemberListRes>> getMarathonDetail(@PathVariable("marathon_seq") int marathonSeq){
        return ResponseEntity.ok(marathonService.getMarathonMemberList(marathonSeq));
    }

    @GetMapping("/rank/{marathon_seq}")
    public ResponseEntity<List<MarthonRankListRes>> getMarathonResult(@PathVariable("marathon_seq") int marathonSeq) {
        return ResponseEntity.ok(marathonService.getMarathonRankList(marathonSeq));
    }

    @PostMapping("/create")
    public ResponseEntity<Integer> startMarathon(Principal principal, @RequestBody MarathonCreateReq marathonCreateReq){
        return ResponseEntity.ok(marathonService.startMarathon(principal,marathonCreateReq));
    }
    @GetMapping("/attend/{marathon_seq}")
    public ResponseEntity<Boolean> saveReadyMarathon(Principal principal, @PathVariable("marathon_seq") int marathonSeq){
        return ResponseEntity.ok(marathonService.isMarathonReady(principal,marathonSeq));
    }
    @PostMapping("/start")
    public ResponseEntity<MarathonGameStartRes> saveStartMarathon(Principal principal, @RequestBody MarathonGameStartReq marathonGameStartReq){
        return new ResponseEntity<>(marathonService.saveStartMarathon(principal,marathonGameStartReq), HttpStatus.OK);
    }
    @PostMapping("/end")
    public ResponseEntity<MarathonGameEndRes> saveEndMarathon(Principal principal, @RequestBody MarathonGameEndReq marathonGameEndReq){
        return new ResponseEntity<>(marathonService.saveEndMarathon(principal,marathonGameEndReq),HttpStatus.OK);
    }



}
