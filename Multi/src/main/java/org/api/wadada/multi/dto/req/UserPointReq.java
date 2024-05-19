package org.api.wadada.multi.dto.req;

import lombok.Data;

@Data
public class UserPointReq {

    private int roomIdx;
    private double latitude;
    private double longitude;
}
