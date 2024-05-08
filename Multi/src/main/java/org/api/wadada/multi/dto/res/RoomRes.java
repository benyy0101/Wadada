package org.api.wadada.multi.dto.res;

import lombok.Builder;
import lombok.Data;
import org.api.wadada.multi.entity.Room;
import org.api.wadada.multi.entity.RoomDocument;

@Data
@Builder
public class RoomRes {

    private int roomIdx;
    
    private String roomTitle;

    private int roomPeople;

    private String roomTag;

    private int roomSecret;


    public static RoomRes of(int roomIdx,Room room){
        return getRoomRes(roomIdx, room.getRoomSecret(), room.getRoomTitle(), room.getRoomPeople(), room.getRoomTag());
    }

    public static RoomRes of(int roomIdx, RoomDocument roomDocument){
        return getRoomRes(roomIdx, roomDocument.getRoomSecret(), roomDocument.getRoomTitle(), roomDocument.getRoomPeople(), roomDocument.getRoomTag());
    }

    private static RoomRes getRoomRes(int roomIdx, int roomSecret2, String roomTitle, int roomPeople, String roomTag) {
        int roomSecret;
        if(roomSecret2 ==0){
            roomSecret = -1;
        }
        else{
            roomSecret = roomSecret2;
        }

        return RoomRes.builder()
                .roomIdx(roomIdx)
                .roomTitle(roomTitle)
                .roomPeople(roomPeople)
                .roomTag(roomTag)
                .roomSecret(roomSecret)
                .build();
    }



}
