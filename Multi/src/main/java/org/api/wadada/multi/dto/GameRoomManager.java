package org.api.wadada.multi.dto;

import lombok.extern.slf4j.Slf4j;
import org.api.wadada.multi.dto.game.GameUpdateListener;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Service
@Slf4j

public class GameRoomManager {

    private final List<GameRoomDto> playrooms;
    private static final int MAX_ROOMS = 40;
    private int[] roomSeqList = new int[40];
    private final ConcurrentMap<Integer,Integer> roomSeqTable = new ConcurrentHashMap<>();

    public GameRoomManager() {
        this.playrooms = new ArrayList<>(MAX_ROOMS);

        for (int i = 0; i < MAX_ROOMS; i++) {
            playrooms.add(null);
        }
    }

    public int addRoom(int roomSeq,GameRoomDto room) throws Exception {

//        roomSeqTable.put(room.getRoomIdx(),roomSeq);
        Optional<Integer> emptyIndex = getEmptyIndex();
        if (emptyIndex.isPresent()) {
            room.setListeners(new ArrayList<>());
            playrooms.set(emptyIndex.get(), room);
            return emptyIndex.get();
        } else {
            throw new Exception("방이 가득 차서 생성 불가");
        }
    }

    public void removeRoom(int index) {
        if (index < 0 || index >= MAX_ROOMS) {
            throw new IndexOutOfBoundsException("잘못된 방 인덱스");
        }
        GameRoomDto room = playrooms.get(index);
        // 해당 방 멤버 모두 삭제
        if(room != null){
            room.removeAllMembers();
        }
        playrooms.set(index, null);
    }

    public Optional<Integer> getEmptyIndex() {
        for (int i = 0; i < MAX_ROOMS; i++) {
            if (playrooms.get(i) == null) {
                return Optional.of(i);
            }
        }
        return Optional.empty();
    }

    public Map<Integer,GameRoomDto> getAllRooms() {
        Map<Integer,GameRoomDto> activeRooms = new HashMap<>();
        for (GameRoomDto room : playrooms) {
            if (room != null) {
                activeRooms.put(room.getRoomSeq(),room);
            }
        }
        return activeRooms;
    }

    public int getRoomCount() {
        int count = 0;
        for (GameRoomDto room : playrooms) {
            if (room != null) {
                count++;
            }
        }
        return count;
    }



}