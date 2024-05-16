package org.api.wadada.multi.dto.req;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.api.wadada.util.PointDeserializer;
import org.locationtech.jts.geom.Point;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class GameEndReq {
    private Integer roomSeq;
    private String recordImage;
    private Integer recordDist;
    private Integer recordTime;

    @JsonDeserialize(using = PointDeserializer.class)
    private Point recordStartLocation;

    @JsonDeserialize(using = PointDeserializer.class)
    private Point recordEndLocation;
    private String recordWay;
    private String recordSpeed;
    private String recordHeartbeat;
    private String recordPace;
    private Integer recordRank;
}
