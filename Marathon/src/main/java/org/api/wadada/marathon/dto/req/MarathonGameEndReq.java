package org.api.wadada.marathon.dto.req;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.api.wadada.util.PointDeserializer;
import org.locationtech.jts.geom.Point;

@Builder
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class MarathonGameEndReq {
    private int marathonSeq;
    private Byte marathonRecordRank;
    @JsonDeserialize(using = PointDeserializer.class)
    private Point marathonRecordStart; // Point 타입은 적절한 클래스로 대체 필요
    private String marathonRecodeWay; // JSON 타입 처리를 위해 String 사용
    @JsonDeserialize(using = PointDeserializer.class)
    private Point marathonRecordEnd; // Point 타입은 적절한 클래스로 대체 필요
    private Integer marathonRecordDist;
    private Integer marathonRecordTime;
    private String marathonRecodeImage;
    private String marathonRecodePace; // JSON 타입 처리를 위해 String 사용
    private Integer marathonRecordMeanPace;
    private String marathonRecordSpeed; // JSON 타입 처리를 위해 String 사용
    private Integer marathonRecordMeanSpeed;
    private String marathonRecordHeartbeat; // JSON 타입 처리를 위해 String 사용
    private Byte marathonRecordMeanHeartbeat ;
    private boolean marathonRecordIsWin;

}
