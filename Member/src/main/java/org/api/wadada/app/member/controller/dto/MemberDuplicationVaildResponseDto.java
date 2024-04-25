package org.api.wadada.app.member.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@Builder
@Getter
@NoArgsConstructor
public class MemberDuplicationVaildResponseDto {
    private boolean Is_duplication;
}
