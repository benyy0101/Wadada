package org.api.wadada.multi.dto.res;

import lombok.Builder;
import lombok.Data;
import org.api.wadada.multi.entity.Room;

@Data
@Builder
public class RoomRes {

    private int roomIdx;

    private String roomTitle;

    private int roomPeople;

    private String roomTag;

    private int roomSecret;

    public static RoomRes of(int roomIdx,Room room){
        int roomSecret;
        if(room.getRoomSecret()==0){
            roomSecret = -1;
        }
        else{
            roomSecret = room.getRoomSecret();
        }

        return RoomRes.builder()
                .roomIdx(roomIdx)
                .roomTitle(room.getRoomTitle())
                .roomPeople(room.getRoomPeople())
                .roomTag(room.getRoomTag())
                .roomSecret(roomSecret)
                .build();
    }

}
