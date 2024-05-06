package org.api.wadada.multi.dto;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;


// 전체 방 관리
@Service
@Slf4j
public class RoomManager {

    private static final int MAX_ROOMS = 40;
    private List<RoomDto> rooms;
    private int[] roomSeqList = new int[40];

    public RoomManager() {
        this.rooms = new ArrayList<>(MAX_ROOMS);
        for (int i = 0; i < MAX_ROOMS; i++) {
            rooms.add(null);
        }
    }

    public int addRoom(int roomSeq,RoomDto room) throws Exception {
        Optional<Integer> emptyIndex = getEmptyIndex();
        if (emptyIndex.isPresent()) {
            roomSeqList[emptyIndex.get()] = roomSeq;
            log.info("메모리 방 리스트      "+ Arrays.toString(roomSeqList));
            rooms.set(emptyIndex.get(), room);
            return emptyIndex.get();
        } else {
            throw new Exception("Cannot add more rooms, all slots are full.");
        }
    }

    public void removeRoom(int index) {
        if (index < 0 || index >= MAX_ROOMS) {
            throw new IndexOutOfBoundsException("Invalid room index.");
        }
        rooms.set(index, null);
    }

    public Optional<Integer> getEmptyIndex() {
        for (int i = 0; i < MAX_ROOMS; i++) {
            if (rooms.get(i) == null) {
                return Optional.of(i);
            }
        }
        return Optional.empty();
    }

    public List<RoomDto> getAllRooms() {
        List<RoomDto> activeRooms = new ArrayList<>();
        for (RoomDto room : rooms) {
            if (room != null) {
                activeRooms.add(room);
            }
        }
        return activeRooms;
    }

    public int getRoomCount() {
        int count = 0;
        for (RoomDto room : rooms) {
            if (room != null) {
                count++;
            }
        }
        return count;
    }



}
