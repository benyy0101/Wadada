package org.api.wadada.auth.controller.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import org.api.wadada.auth.JwtToken;

@Getter
@Builder
@AllArgsConstructor
public class LoginResponseDto {
    @JsonProperty("member_id")
    private String memberId;
    @JsonProperty("kakao_nickname")
    private String nickname;
    @JsonProperty("kakao_email")
    private String email;
    @JsonProperty("jwtToken")
    private JwtToken jwtToken;
}
