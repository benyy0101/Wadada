package org.api.wadada.app.member.controller.dto;

import jakarta.validation.constraints.Null;
import jakarta.validation.constraints.Pattern;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class MemberUpdateRequestDto {
    @Pattern(regexp = "(?=.*[0-9])(?=.*[a-zA-Z])(?=.*\\W)(?=\\S+$).{8,16}", message = "비밀번호는 8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.")
    private String password;
    private String nickname;
    @Null
    private String profileImage;

    @Builder
    public MemberUpdateRequestDto(String password, String nickname, String profileImage) {
        this.password = password;
        this.nickname = nickname;
        this.profileImage = profileImage;
    }

}
