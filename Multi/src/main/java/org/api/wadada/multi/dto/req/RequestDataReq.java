package org.api.wadada.multi.dto.req;

import lombok.Data;

@Data
public class RequestDataReq {

    private int roomSeq;
    private String userName;
    private int userDist;
    private int userTime;
    private double userLat;
    private double userLng;
}
