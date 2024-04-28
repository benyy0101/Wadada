package org.api.wadada.app.mypage.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecordListDto {
    private List<RecordDto> monthlyRecord;
}
