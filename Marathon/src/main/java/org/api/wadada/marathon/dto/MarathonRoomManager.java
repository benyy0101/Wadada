package org.api.wadada.marathon.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@AllArgsConstructor
@Service
@Getter
@Builder
public class MarathonRoomManager {
    private final List<MarathonRoomDto> rooms;
    private static final int MAX_ROOMS = 40;
    public MarathonRoomManager() {
        this.rooms = new ArrayList<>(MAX_ROOMS);
        for (int i = 0; i < MAX_ROOMS; i++) {
            rooms.add(null);
        }
    }

    public int addRoom(MarathonRoomDto room) throws Exception {
        Optional<Integer> emptyIndex = getEmptyIndex();
        if (emptyIndex.isPresent()) {
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

    public Map<Integer,MarathonRoomDto> getAllRooms() {
        Map<Integer,MarathonRoomDto> activeRooms = new HashMap<>();
        for (MarathonRoomDto room : rooms) {
            if (room != null) {
                activeRooms.put(room.getRoomSeq(),room);
            }
        }
        return activeRooms;
    }
    public int getRoomCount() {
        int count = 0;
        for (MarathonRoomDto room : rooms) {
            if (room != null) {
                count++;
            }
        }
        return count;
    }

}
