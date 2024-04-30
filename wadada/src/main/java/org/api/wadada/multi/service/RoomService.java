package org.api.wadada.multi.service;

import lombok.RequiredArgsConstructor;
import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.dto.res.AttendRoomRes;
import org.api.wadada.multi.dto.res.LeaveRoomRes;
import org.api.wadada.multi.dto.res.RoomMemberRes;
import org.api.wadada.multi.repository.RoomRepository;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;

public interface RoomService {

    HashMap<Integer, List<RoomMemberRes>> createRoom(CreateRoomReq createRoomReq, Principal principal) throws Exception;

    HashMap<Integer, List<RoomMemberRes>> attendRoom(int roomIdx,Principal principal);

    HashMap<Integer, List<RoomMemberRes>> leaveRoom(int roomIdx,Principal principal);

    HashMap<Integer, List<RoomMemberRes>> changeReady(int roomIdx,Principal principal);
}
