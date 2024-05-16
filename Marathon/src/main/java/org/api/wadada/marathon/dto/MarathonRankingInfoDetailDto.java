package org.api.wadada.marathon.dto;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@ToString
public class MarathonRankingInfoDetailDto {
    private String memberImage;
    private String memberName;
    private int memberDist;
    private int memberTime;
}
