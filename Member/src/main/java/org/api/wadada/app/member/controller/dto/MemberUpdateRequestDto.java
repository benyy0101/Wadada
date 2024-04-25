package org.api.wadada.app.member.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MemberUpdateRequestDto {
    private String memberNickname;
    private LocalDate memberBirthday;
    private String memberGender; // 'F' 또는 'M'
    private String memberEmail; // Optional
    private String memberProfileImage; // S3에서 반환된 이미지 주소
}
