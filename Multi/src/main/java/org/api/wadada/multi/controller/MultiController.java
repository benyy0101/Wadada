package org.api.wadada.multi.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.multi.dto.game.GameMessage;
import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.dto.req.GameEndReq;
import org.api.wadada.multi.dto.req.GameStartReq;
import org.api.wadada.multi.dto.res.GameEndRes;
import org.api.wadada.multi.dto.res.GameResultRes;
import org.api.wadada.multi.dto.res.GameStartRes;
import org.api.wadada.multi.dto.res.RoomMemberRes;
import org.api.wadada.multi.exception.CanNotJoinRoomException;
import org.api.wadada.multi.exception.CreateRoomException;
import org.api.wadada.multi.exception.NotFoundMemberException;
import org.api.wadada.multi.exception.NotFoundRoomException;
import org.api.wadada.multi.service.MultiRecordService;
import org.api.wadada.multi.service.RoomService;
import org.locationtech.jts.io.ParseException;
import org.springframework.context.event.EventListener;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.socket.messaging.SessionConnectEvent;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;


@Slf4j
@Controller
@RequestMapping("/Multi")
@RequiredArgsConstructor
public class MultiController {

    private final RoomService roomService;
    private final MultiRecordService multiRecordService;
    @EventListener
    public void handleWebSocketConnectListener(SessionConnectEvent event) {
        log.info("Received a new web socket connection");
    }

    @PostMapping("/create")
    public ResponseEntity<?> createRoom(@RequestBody CreateRoomReq createRoomReq, Principal principal) throws Exception {
        try{
            HashMap<Integer, List<RoomMemberRes>> result = roomService.createRoom(createRoomReq,principal);
            return new ResponseEntity<>(result,HttpStatus.OK);
        }catch (NotFoundMemberException e1){
            return new ResponseEntity<>("없는 멤버 정보입니다.",HttpStatus.NOT_ACCEPTABLE);
        }catch (CreateRoomException e2){
            return new ResponseEntity<>("최대 방 초과입니다.",HttpStatus.NOT_ACCEPTABLE);
        }

    }

    @MessageMapping("/attend/{roomIdx}")
    @SendTo("/sub/attend/{roomIdx}")
    public ResponseEntity<?> attendRoom(@DestinationVariable int roomIdx, Principal principal){
        try{
            HashMap<Integer, List<RoomMemberRes>> result = roomService.attendRoom(roomIdx,principal);
            return new ResponseEntity<>(result,HttpStatus.OK);

        }catch (NotFoundMemberException e1){
            return new ResponseEntity<>("없는 멤버 정보입니다.",HttpStatus.NOT_ACCEPTABLE);
        }catch (NotFoundRoomException e2){
            return new ResponseEntity<>("참가할 방이 없습니다.",HttpStatus.NOT_ACCEPTABLE);
        }catch(CanNotJoinRoomException e3){
            return new ResponseEntity<>("방이 가득찼습니다.",HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @MessageMapping("/out/{roomIdx}")
    @SendTo("/sub/attend/{roomIdx}")
    public ResponseEntity<?> leaveRoom(@DestinationVariable int roomIdx, Principal principal){
        try{
            HashMap<Integer, List<RoomMemberRes>> result = roomService.leaveRoom(roomIdx,principal);
            return new ResponseEntity<>(result,HttpStatus.OK);
        }catch (NotFoundMemberException e1){
            return new ResponseEntity<>("없는 멤버 정보입니다.",HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @MessageMapping("/change/ready/{roomIdx}")
    @SendTo("/sub/attend/{roomIdx}")
    public ResponseEntity<?> changeReady(@DestinationVariable int roomIdx, Principal principal){
        try {
            HashMap<Integer, List<RoomMemberRes>> result = roomService.changeReady(roomIdx, principal);
            return new ResponseEntity<>(result, HttpStatus.OK);
        }
        catch (NotFoundMemberException e1){
            return new ResponseEntity<>("없는 멤버 정보입니다.",HttpStatus.NOT_ACCEPTABLE);
        }
    }

//    @MessageMapping("/start/game/{roomIdx}")
//    @SendTo("/sub/attend/{roomIdx}")
//    public ResponseEntity<String> startGame(@DestinationVariable int roomIdx){
//        roomService.startGame(roomIdx);
//        return new ResponseEntity<>("Game Start",HttpStatus.OK);
//    }
    @GetMapping("/tag/{tag}")
    public ResponseEntity<?> getTagRoomList(@PathVariable String tag) throws Exception {
        log.info(tag);
        return new ResponseEntity<>(roomService.findByRoomTag(tag),HttpStatus.OK);
    }
    @GetMapping("/{mode}")
    public ResponseEntity<?> getModeRoomList(@PathVariable int mode){
        return new ResponseEntity<>(roomService.getRoomList(mode),HttpStatus.OK);
    }
    // Game Logic



    @MessageMapping("/game/start/{roomIdx}")
    @SendTo("/sub/attend/{roomIdx}")
    public ResponseEntity<String> startGameInfo(@DestinationVariable int roomIdx) {
        // 게임 시작 정보 메시지 생성 (API 요청 URL 포함)

        String message = GameMessage.GAME_START_INFO_REQUEST.toJson();
        // 해당 방의 모든 사용자에게 메시지 전송
        //messagingTemplate.convertAndSend("/sub/attend/" + roomIdx, message);
        roomService.startGame(roomIdx);
        return new ResponseEntity<>(message,HttpStatus.OK);
    }



    // Game 관련 Logic
    @PostMapping("/start")
    public ResponseEntity<GameStartRes> saveStartMulti(Principal principal, @RequestBody GameStartReq gameStartReq){

        try {
            return new ResponseEntity<>(multiRecordService.saveStartMulti(principal,gameStartReq),HttpStatus.OK);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }

    @PostMapping("/result")
    public ResponseEntity<GameEndRes> saveEndMulti(Principal principal, @RequestBody GameEndReq gameEndReq){

        try {
            return new ResponseEntity<>(multiRecordService.saveEndMulti(principal,gameEndReq),HttpStatus.OK);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }

    @GetMapping("/analysis/{room_seq}")
    public ResponseEntity<GameResultRes> getResultMulti(Principal principal,@PathVariable("room_seq") Integer roomSeq){

        try {
            return new ResponseEntity<>(multiRecordService.getResultMulti(principal,roomSeq),HttpStatus.OK);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }


}
