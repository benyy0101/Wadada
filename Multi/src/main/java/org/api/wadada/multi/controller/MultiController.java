package org.api.wadada.multi.controller;

import lombok.Builder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.dto.req.GameStartReq;
import org.api.wadada.multi.dto.res.GameStartRes;
import org.api.wadada.multi.service.RoomService;
import org.springframework.context.event.EventListener;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.socket.messaging.SessionConnectEvent;

import java.security.Principal;


@Slf4j
@Controller
@RequestMapping("/Multi")
@RequiredArgsConstructor
public class MultiController {

    private final RoomService roomService;

    @EventListener
    public void handleWebSocketConnectListener(SessionConnectEvent event) {
        log.info("Received a new web socket connection");
    }

    @PostMapping("/create")
    public ResponseEntity<?> createRoom(@RequestBody CreateRoomReq createRoomReq, Principal principal) throws Exception {
        return new ResponseEntity<>(roomService.createRoom(createRoomReq,principal),HttpStatus.OK);
    }

    @MessageMapping("/attend/{roomIdx}")
    @SendTo("/sub/attend/{roomIdx}")
    public ResponseEntity<?> attendRoom(@DestinationVariable int roomIdx, Principal principal){
        return new ResponseEntity<>(roomService.attendRoom(roomIdx,principal),HttpStatus.OK);
    }

    @MessageMapping("/out/{roomIdx}")
    @SendTo("/sub/attend/{roomIdx}")
    public ResponseEntity<?> leaveRoom(@DestinationVariable int roomIdx, Principal principal){
        return new ResponseEntity<>(roomService.leaveRoom(roomIdx,principal),HttpStatus.OK);
    }

    @MessageMapping("/change/ready/{roomIdx}")
    @SendTo("/sub/attend/{roomIdx}")
    public ResponseEntity<?> changeReady(@DestinationVariable int roomIdx, Principal principal){
        return new ResponseEntity<>(roomService.changeReady(roomIdx,principal),HttpStatus.OK);
    }


    // Game 관련 Logic
    @PostMapping("/start")
    public ResponseEntity<GameStartRes> saveStartMulti(Principal principal, @RequestBody GameStartReq gameStartReq){

        return ResponseEntity.ok().build();
    }

}
