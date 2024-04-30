package org.api.wadada.auth.controller;


import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.auth.controller.dto.LoginReqeustDto;
import org.api.wadada.auth.controller.dto.LoginResponseDto;
import org.api.wadada.auth.service.OAuthService;
import org.api.wadada.error.errorcode.CommonErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.api.wadada.util.MemberUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Slf4j
public class OAuthController {

    private final OAuthService oAuthService;

    @Value("${spring.jwt.refresh-token-validity-in-seconds}")
    private long refreshTokenValidityInSeconds;

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDto> kakaoLogin(@RequestBody LoginReqeustDto req) throws IOException {
        System.out.println(req.getCode());
        LoginResponseDto res = oAuthService.kakaoOAuthLogin(req.getCode());
        HttpHeaders headers = getHeadersWithCookie(res);
        return new ResponseEntity<>(res, headers, HttpStatus.OK);
    }

    @GetMapping("/reissue")
    public ResponseEntity<String> reissue(HttpServletRequest req) {
        Cookie[] cookies = req.getCookies();
        if (cookies == null) throw new RestApiException(CommonErrorCode.WRONG_REQUEST, "쿠키가 존재하지 않습니다");

        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("refreshToken")){
                String encryptedRefreshToken = URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8);
                String newAccessToken = oAuthService.reissueAccessToken(encryptedRefreshToken);
                return ResponseEntity.ok(newAccessToken);
            }
        }
        return new ResponseEntity<String>("필요한 쿠키가 존재하지 않습니다", HttpStatus.BAD_REQUEST);
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logout(){
        String memberId = MemberUtil.getMemberId();
        oAuthService.logout(memberId);
        return ResponseEntity.ok("logout");
    }

    private HttpHeaders getHeadersWithCookie(LoginResponseDto res) {
        try {
            // refreshToken 값을 URL 인코딩 적용
            String encodedRefreshToken = URLEncoder.encode(res.getJwtToken().deleteRefreshToken(),StandardCharsets.UTF_8);

            ResponseCookie cookie = ResponseCookie.from("refreshToken", encodedRefreshToken)
                    .maxAge(refreshTokenValidityInSeconds)
                    .path("/")
                    .secure(true)
                    .sameSite("None")
                    .httpOnly(true)
                    .build();

            HttpHeaders headers = new HttpHeaders();
            headers.add("Set-Cookie", cookie.toString());
            return headers;
        } catch (Exception e) {
            // 인코딩 실패 시 예외 처리
            e.printStackTrace();
            return null;
        }
    }

}
