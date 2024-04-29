package org.api.wadada.multi.service;

import lombok.RequiredArgsConstructor;
import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.repository.RoomRepository;
import org.springframework.stereotype.Service;

public interface RoomService {

    void createRoom(CreateRoomReq createRoomReq);
}
