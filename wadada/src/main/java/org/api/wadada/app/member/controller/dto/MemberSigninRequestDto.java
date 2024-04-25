package org.api.wadada.app.member.controller.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class MemberSigninRequestDto {
    @NotNull
    @Pattern(regexp = "[a-z0-9]*", message = "대문자는 사용할 수 없습니다")
    public String memberId;
    @NotNull
    @Pattern(regexp = "(?=.*[0-9])(?=.*[a-zA-Z])(?=.*\\W)(?=\\S+$).{8,16}", message = "비밀번호는 8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.")
    public String password;
    @NotNull
    public String nickname;
    @Setter
    public List<String> roles;

    @Builder
    public MemberSigninRequestDto(String memberId, String password, String nickname) {
        this.memberId = memberId;
        this.password = password;
        this.nickname = nickname;
    }
}
