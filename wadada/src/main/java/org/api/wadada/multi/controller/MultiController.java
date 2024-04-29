package org.api.wadada.multi.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.entity.Member;
import org.api.wadada.multi.service.RoomService;
import org.springframework.context.event.EventListener;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
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
    public ResponseEntity<?> createRoom(@RequestBody CreateRoomReq createRoomReq){
        log.info(createRoomReq.toString());
        roomService.createRoom(createRoomReq);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @MessageMapping("/attend/{roomSeq}")
    @SendTo("/sub/attend/{roomSeq}")
    public String attendRoom(@DestinationVariable int roomSeq, Principal principal){
        Member member = (Member)((Authentication) principal).getPrincipal();
        log.info(member.toString());
        //        System.out.println("userDetails.toString() = " + userDetails.toString());
        return "hihi";
    }

    @MessageMapping("/out/{roomSeq}")
    @SendTo("/sub/{roomSeq}")
    public ResponseEntity<?> outRoom(@DestinationVariable int roomSeq){
        return null;
    }
}
