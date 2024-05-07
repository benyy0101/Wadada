package org.api.wadada.multi.dto.req;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class GameEndReq {
    private String recordMode;
    private String recordImage;
    private Integer recordDist;
    private Integer recordTime;
    private Point recordStartLocation;
    private Point recordEndLocation;
    private String recordWay;
    private String recordSpeed;
    private String recordHeartbeat;
    private String recordPace;
    private Integer recordRank;
}
