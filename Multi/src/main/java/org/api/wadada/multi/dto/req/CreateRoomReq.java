package org.api.wadada.multi.dto.req;

import lombok.Data;

@Data
public class CreateRoomReq {

    private int roomPeople;
    private int roomDist;
    private int roomMode;
    private int roomSecret;
    private String roomTag;
    private int roomTime;
    private int roomMaker;
    private String roomTitle;

}
