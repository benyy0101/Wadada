package org.api.wadada.marathon.dto;


import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@ToString
@Setter
public class MemberInfo {
    private int MemberSeq;
    private String MemberName;
    private LocalDateTime registTime;
    private int curRoom;
    private int curIndex;
    private int dist;
    private String image;
    private int time;
    private List<MarathonRankingInfoDetailDto> rankings;
    private int memberRank;

    public void updatememberLocation(int curRoom, int curIndex){
        this.curIndex=curIndex;
        this.curRoom=curRoom;
    }

    public void resetRankings(){
        rankings = new ArrayList<>();
    }

}
