package org.api.wadada.multi.service;

import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.dto.res.RoomMemberRes;
import org.api.wadada.multi.dto.res.RoomRes;
import org.api.wadada.multi.dto.res.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;

public interface RoomService {

//    HashMap<Integer, CreateRoomRes> createRoom(CreateRoomReq createRoomReq, Principal principal) throws Exception;
    TempRes createRoom(CreateRoomReq createRoomReq, Principal principal) throws Exception;


    HashMap<Integer, List<RoomMemberRes>> attendRoom(int roomIdx,Principal principal);

    HashMap<Integer, List<RoomMemberRes>> leaveRoom(int roomIdx,Principal principal);

    HashMap<Integer, List<RoomMemberRes>> changeReady(int roomIdx,Principal principal);

    void startGame(int roomIdx);


    List<RoomRes> getRoomList(int mode);

    List<RoomRes> findByRoomTag(String roomTag) throws Exception;

}
