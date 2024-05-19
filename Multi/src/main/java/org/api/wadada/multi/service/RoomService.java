package org.api.wadada.multi.service;

import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.dto.req.UserPointReq;
import org.api.wadada.multi.dto.res.AttendRoomRes;
import org.api.wadada.multi.dto.res.LeaveRoomRes;
import org.api.wadada.multi.dto.res.RoomMemberRes;
import org.api.wadada.multi.dto.res.RoomRes;
import org.api.wadada.multi.dto.res.*;
import org.api.wadada.multi.repository.RoomRepository;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.io.ParseException;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;

public interface RoomService {

//    HashMap<Integer, CreateRoomRes> createRoom(CreateRoomReq createRoomReq, Principal principal) throws Exception;
    PostRoomRes createRoom(CreateRoomReq createRoomReq, Principal principal) throws Exception;


    HashMap<Integer, List<RoomMemberRes>> attendRoom(int roomIdx,Principal principal);

    HashMap<Integer, List<RoomMemberRes>> leaveRoom(int roomIdx,Principal principal);

    HashMap<Integer, List<RoomMemberRes>> changeReady(int roomIdx,Principal principal);

    void startGame(int roomIdx);


    List<RoomRes> getRoomList(int mode);

    List<RoomRes> findByRoomTag(String roomTag) throws Exception;

    void getFlagPoint(int roomIdx);

    void saveUserPoint(UserPointReq userPointReq);

}
