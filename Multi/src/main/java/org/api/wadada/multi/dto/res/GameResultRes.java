package org.api.wadada.multi.dto.res;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class GameResultRes {
    private Integer multiRecordRank;
    private String multiRecordPace;
    private String multiRecordImage;
    private Integer multiRecordDist;
    private Integer multiRecordTime;
    private String multiRecordStartLocation;
    private String multiRecordEndLocation;
    private String multiRecordSpeed;
    private String multiRecordHeartbeat;
    private Integer multiRecordMeanSpeed;
    private Integer multiRecordMeanPace;
    private Integer multiRecordMeanHeartbeat;
}
