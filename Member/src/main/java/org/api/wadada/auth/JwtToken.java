package org.api.wadada.auth;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_NULL;

@Builder
@AllArgsConstructor
@Getter
@JsonInclude(NON_NULL) // refreshToken을 삭제해서 클라이언트에 반환하기 때문에 null은 response에 자동 제외되도록
public class JwtToken{
    private String grantType;
    private String accessToken;
    private String refreshToken;

    public String deleteRefreshToken(){
        String refreshToken = this.refreshToken;
        this.refreshToken = null;
        return refreshToken;
    }
}
