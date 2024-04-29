package org.api.wadada.app.mypage.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.geo.Point;

import java.time.Duration;
import java.time.LocalDateTime;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SingleRecordDto {
    private String recordType;
    private String recordImage;
    private Integer recordDist;
    private Integer recordTime;
    private String recordStartLocation;
    private String recordEndLocation;
    private String recordSpeed;
    private String recordHeartBeat;
    private String recordPace;
    private LocalDateTime recordCreatedAt;
    private Integer recordMeanPace;
    private Integer recordMeanSpeed;
    private Integer recordMeanHeartbeat;


}
