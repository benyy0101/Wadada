package org.api.wadada.marathon.dto;


import lombok.*;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@ToString
public class MemberInfo {
    private int MemberSeq;
    private String MemberName;
    private LocalDateTime registTime;
}
