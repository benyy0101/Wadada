package org.api.wadada.app.mypage.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RecordDetailDto {
    private String memberNickname;
    private String memberProfileImage;
    private Byte memberRank;
    private Integer memberTime;


}
