package org.api.wadada.multi.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.multi.dto.req.CreateRoomReq;
import org.api.wadada.multi.entity.Room;
import org.api.wadada.multi.repository.RoomRepository;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class RoomServiceImpl implements RoomService{

    private final RoomRepository roomRepository;
    @Override
    public void createRoom(CreateRoomReq createRoomReq) {
        Room room = Room.builder()
                .roomDist(createRoomReq.getRoomDist())
                .roomMaker(createRoomReq.getRoomMaker())
                .roomTime(createRoomReq.getRoomTime())
                .roomMode(createRoomReq.getRoomMode())
                .roomTag(createRoomReq.getRoomTag())
                .roomSecret(createRoomReq.getRoomSecret())
                .roomPeople(createRoomReq.getRoomPeople())
                .roomTitle(createRoomReq.getRoomTitle())
                .roomMaker(62)
                .build();

        roomRepository.save(room);
    }
}
