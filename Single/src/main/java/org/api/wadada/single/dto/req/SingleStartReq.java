package org.api.wadada.single.dto.req;

import lombok.Data;

@Data
public class SingleStartReq {

    private int memberSeq;
    private String recordStartLocation;
    private int recordMode;

}
