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
public class GameStartReq {
    private String recordStartLocation;
    private Integer roomSeq;
    private Integer recordPeople;
}
