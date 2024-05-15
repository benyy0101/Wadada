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

    private List<MarathonRankingInfoDetailDto> rankings;
}
