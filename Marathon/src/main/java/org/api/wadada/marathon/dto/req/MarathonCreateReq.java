package org.api.wadada.marathon.dto.req;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class MarathonCreateReq {
    private short marathonRound;
    private String marathonTitle;
    private int marathonParticipate;
    private short marathonGoal;
    private byte marathonType;
    private String marathonText;
    private int marathonDist;
    private LocalDateTime marathonStart;
    private LocalDateTime marathonEnd;

}
