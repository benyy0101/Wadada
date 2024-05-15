package org.api.wadada.marathon.dto;


import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@ToString
public class MemberInfo {
    private int MemberSeq;
    private String MemberName;
    private LocalDateTime registTime;
    private int curRoom;
    private int curIndex;

    private List<MarathonRankingInfoDetailDto> rankings;

    public void updatememberLocation(int curRoom, int curIndex){
        this.curIndex=curIndex;
        this.curRoom=curRoom;
    }

}
