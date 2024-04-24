package org.api.wadada.single.dto.res;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Builder
public class MainRes {

    // 총 운동시간
    private int recordTime;

    //총 거리
    private double dist;

    //평균 속력
    private String speed;

    //평균 심박수
    private String recordHeartbeat;

    //평균 페이스
    private String recordPace;

}
