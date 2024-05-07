package org.api.wadada.app.member.controller.dto;

import lombok.*;

import java.time.LocalDate;
@Builder
@Getter
@NoArgsConstructor
@ToString
public class MemberDetailResponseDto {
    public MemberDetailResponseDto(String memberNickname, LocalDate memberBirthday, String memberGender, String memberMainEmail, String memberProfileImage, int memberLevel, Byte memberExp) {
        this.memberNickname = memberNickname;
        this.memberBirthday = memberBirthday;
        this.memberGender = memberGender;
        this.memberMainEmail = memberMainEmail;
        this.memberProfileImage = memberProfileImage;
        this.memberLevel = memberLevel;
        this.memberExp = memberExp;
    }

    private String memberNickname;
    private LocalDate memberBirthday;
    private String memberGender; // 'F' 또는 'M' 만 허용
    private String memberMainEmail; // Optional
    private String memberProfileImage;
    private int memberLevel;
    private Byte memberExp;


}
