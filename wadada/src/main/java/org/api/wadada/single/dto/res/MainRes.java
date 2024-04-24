package org.api.wadada.single.dto.res;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MainRes {

    // 총 운동시간
    private int recordTime;

    //총 거리
    private double recordDist;

    //평균 속력
    private double recordSpeed;

    //평균 심박수
    private double recordHeartbeat;

    //평균 페이스
    private double recordPace;

}
