package org.api.wadada.multi.dto.req;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.geolatte.geom.Point;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class GameStartReq {
    private Integer recordMode;
    private Point recordStartLocation;
    private Integer recordPeople;
}
