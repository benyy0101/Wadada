package org.api.wadada.single.dto.req;

import lombok.Data;

@Data
public class SingleEndReq {

    private int memberSeq;
    private int singleRecordSeq;
    private String recordStartLocation;
    private String recordEndLocation;
    private String recordImage;
    private int recordDist;
    private int recordTime;

    private String recordWay;
    private String recordSpeed;
    private String recordHeartbeat;
    private String recordPace;

    private int recordMeanSpeed;
    private int recordMeanHeartbeat;
    private int recordMeanPace;

}
