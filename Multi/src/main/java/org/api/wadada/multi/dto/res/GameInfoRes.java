package org.api.wadada.multi.dto.res;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GameInfoRes {

    private int memberRank;
    private String memberProfile;
    private String memberNickname;
    private int memberDist;
    private int memberTime;

}
