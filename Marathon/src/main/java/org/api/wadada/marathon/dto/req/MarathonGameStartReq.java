package org.api.wadada.marathon.dto.req;

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
public class MarathonGameStartReq {
    @JsonDeserialize(using = PointDeserializer.class)
    private Point recordStartLocation;
    private Integer marathonSeq;
    private Integer recordPeople;
    private boolean marathonRecordIsWin;
}
