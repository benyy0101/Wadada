package org.api.wadada.marathon.dto.req;

import lombok.Data;

@Data
public class RequestDataReq {

    private int roomSeq;
    private String userName;
    private int userDist;
    private int userTime;
}
