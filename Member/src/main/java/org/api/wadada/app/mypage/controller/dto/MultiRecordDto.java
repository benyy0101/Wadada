package org.api.wadada.app.mypage.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MultiRecordDto {
    private String recordType;
    private Byte recordRank;
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
    private Byte recordMeanHeartbeat;
    private List<RecordDetailDto> rankings;
}
