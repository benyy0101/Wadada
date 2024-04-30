package org.api.wadada.multi.service;

import lombok.RequiredArgsConstructor;
import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.dto.res.AttendRoomRes;
import org.api.wadada.multi.dto.res.LeaveRoomRes;
import org.api.wadada.multi.repository.RoomRepository;
import org.springframework.stereotype.Service;

import java.security.Principal;

public interface RoomService {

    void createRoom(CreateRoomReq createRoomReq, Principal principal);

    AttendRoomRes attendRoom(Principal principal);

    LeaveRoomRes leaveRoom(Principal principal);
}