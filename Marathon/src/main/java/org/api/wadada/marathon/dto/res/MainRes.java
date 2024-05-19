package org.api.wadada.marathon.dto.res;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MainRes {
    //마라톤 번호
    private int marathonSeq;

    //마라톤 회차
    private Short marathonRound;

    //총 거리
    private int marathonDist;

    //참여 인원
    private int marathonParticipate;

    // 시작시간
    private LocalDateTime marathonStart;

    // 끝나는 시간
    private LocalDateTime marathonEnd;

    private Boolean isDeleted;




}
