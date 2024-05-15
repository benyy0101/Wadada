package org.api.wadada.marathon.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.marathon.dto.MessageDto;
import org.api.wadada.marathon.dto.req.MarathonCreateReq;
import org.api.wadada.marathon.dto.req.MarathonGameEndReq;
import org.api.wadada.marathon.dto.req.MarathonGameStartReq;
import org.api.wadada.marathon.dto.res.*;
import org.api.wadada.marathon.service.MarathonService;
import org.api.wadada.marathon.service.MessageService;
import org.springframework.context.event.EventListener;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
//import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.socket.messaging.SessionConnectEvent;

import java.security.Principal;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/Marathon")
@Slf4j
public class MarathonController {

    private final MarathonService marathonService;
    private final MessageService messageService;


    @EventListener
    public void handleWebSocketConnectListener(SessionConnectEvent event) {
        log.info("Received a new web socket connection");
    }
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
    public ResponseEntity<Integer> saveReadyMarathon(Principal principal, @PathVariable("marathon_seq") int marathonSeq) throws Exception {
        return ResponseEntity.ok(marathonService.isMarathonReady(principal,marathonSeq));
    }
    @PostMapping("/start")
    public ResponseEntity<MarathonGameStartRes> saveStartMarathon(Principal principal, @RequestBody MarathonGameStartReq marathonGameStartReq){
        return new ResponseEntity<>(marathonService.saveStartMarathon(principal,marathonGameStartReq), HttpStatus.OK);
    }
    @PostMapping("/result")
    public ResponseEntity<MarathonGameEndRes> saveEndMarathon(Principal principal, @RequestBody MarathonGameEndReq marathonGameEndReq){
        return new ResponseEntity<>(marathonService.saveEndMarathon(principal,marathonGameEndReq),HttpStatus.OK);
    }
    @GetMapping("/end/{room_seq}")
    public ResponseEntity<Boolean> isEndGame(@PathVariable("room_seq") int roomSeq){
        return ResponseEntity.ok(marathonService.isEndGame(roomSeq));
    }





    @MessageMapping("/attend/{roomIdx}")
    @SendTo("/sub/attend/{roomIdx}")
    public ResponseEntity<?> attendRoom(@DestinationVariable int roomIdx, Principal principal){
            return new ResponseEntity<>("방을 만들었습니다",HttpStatus.OK);
    }



    /**
     * Queue로 메시지를 발행
     *
     * @param messageDto 발행할 메시지의 DTO 객체
     * @return ResponseEntity 객체로 응답을 반환
     */
    @PostMapping("/post")
    public ResponseEntity<?> sendMessage(@RequestBody MessageDto messageDto) {
        messageService.sendMessage(messageDto);
        return ResponseEntity.ok("Message sent to RabbitMQ!");
    }

    @PostMapping("/receive")
    public ResponseEntity<?> receiveMessage(@RequestBody MessageDto messageDto) {
        messageService.receiveMessage(messageDto);
        return ResponseEntity.ok("Message sent to RabbitMQ!");
    }


}
