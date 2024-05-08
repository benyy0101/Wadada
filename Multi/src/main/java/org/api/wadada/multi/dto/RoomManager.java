package org.api.wadada.multi.dto;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ConcurrentMap;


// 전체 방 관리
@Service
@Slf4j
public class RoomManager {

    private final List<RoomDto> rooms;
    private static final int MAX_ROOMS = 40;
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
            room.setRoomIdx(emptyIndex.get());
            rooms.set(emptyIndex.get(), room);
            return emptyIndex.get();
        } else {
            throw new Exception("방이 가득 차서 생성 불가");
        }
    }

    public void removeRoom(int index) {
        if (index < 0 || index >= MAX_ROOMS) {
            throw new IndexOutOfBoundsException("잘못된 방 인덱스");
        }
        RoomDto room = rooms.get(index);
        // 해당 방 멤버 모두 삭제
        if(room != null){
            room.removeAllMembers();
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

    public Map<Integer,RoomDto> getAllRooms() {
        Map<Integer,RoomDto> activeRooms = new HashMap<>();
        for (RoomDto room : rooms) {
            if (room != null) {
                activeRooms.put(room.getRoomIdx(),room);
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
