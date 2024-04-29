package org.api.wadada.app.mypage.controller.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecordDto {
    private Integer recordSeq;
    private String recordType;
    private Integer recordDist;
    private LocalDateTime recordCreatedAt;
}