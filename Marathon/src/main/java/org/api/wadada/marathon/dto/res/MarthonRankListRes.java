package org.api.wadada.marathon.dto.res;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MarthonRankListRes {
    private String memberName;
    private String memberImage;
    private int memberDist;
    private int memberTime;
}
