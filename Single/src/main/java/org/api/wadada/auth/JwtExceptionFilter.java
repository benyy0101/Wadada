package org.api.wadada.auth;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.response.ErrorResponse;
import org.springframework.http.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Enumeration;

@Component
@RequiredArgsConstructor
@Slf4j
public class JwtExceptionFilter extends OncePerRequestFilter {

    private final ObjectMapper objectMapper;
    private final JwtTokenProvider jwtTokenProvider;
    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain chain) throws ServletException, IOException {
        try {
            chain.doFilter(req, res);
        } catch (ExpiredJwtException e){
            log.info("expired jwt token, redirect to auth/reissue");
            try {
                RestTemplate restTemplate = new RestTemplate();
                String reissueUrl = "https://k10a704.p.ssafy.io/Wadada/auth/reissue";

                // 요청받은 헤더를 그대로 복사하기
                HttpHeaders headers = new HttpHeaders();
                Enumeration<String> headerNames = req.getHeaderNames();
                while (headerNames.hasMoreElements()) {
                    String headerName = headerNames.nextElement();
                    Enumeration<String> headerValues = req.getHeaders(headerName);
                    while (headerValues.hasMoreElements()) {
                        String headerValue = headerValues.nextElement();
                        headers.add(headerName, headerValue);
                    }
                }

                // 여기서 필요한 경우, 특정 헤더를 수정하거나 추가할 수 있습니다.
                // 예: headers.set("Authorization", "Bearer " + refreshToken);

                HttpEntity<String> entity = new HttpEntity<>(headers);
                headers.setContentType(MediaType.APPLICATION_JSON);
                ResponseEntity<String> response = restTemplate.exchange(reissueUrl, HttpMethod.GET, entity, String.class);
                System.out.println(response.getBody());
                if(response.getStatusCode().is2xxSuccessful()) {
                    // 재발급 받은 토큰으로 요청 헤더 설정
                    String newAccessToken = response.getBody(); // 실제 반환 포맷에 맞게 토큰 추출 방식을 조정해야 합니다.
                    // HttpServletRequestWrapper를 상속받은 커스텀 래퍼 클래스 사용
                    HttpServletRequestWrapper wrappedRequest = new HttpServletRequestWrapper(req) {
                        @Override
                        public String getHeader(String name) {
                            if ("Authorization".equals(name)) {
                                return "Bearer " + newAccessToken;
                            }
                            return super.getHeader(name);
                        }
                    };
                    wrappedRequest.setAttribute("newAccessToken", newAccessToken);
                    Authentication authentication = jwtTokenProvider.getAuthentication(newAccessToken);
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    // 재발급 받은 토큰으로 요청 계속 진행
                    chain.doFilter(wrappedRequest, res);

                } else {
                    // 토큰 재발급 실패 처리
                    makeErrorResponse(res);
                }

                // 이후 로직 처리...
            } catch (Exception reissueException) {
                log.error("Error during token reissue", reissueException);
                makeErrorResponse(res);
            }
        }

        catch (JwtException e) {
            makeErrorResponse(res);
        }
    }

    private void makeErrorResponse(HttpServletResponse res) throws IOException {
        res.setContentType("application/json;charset=UTF-8");
        res.setStatus(CustomErrorCode.NOT_VALID_USER.getHttpStatus().value());
        res.getWriter().write(convertObjectToJson(ErrorResponse.builder()
                .code(CustomErrorCode.NOT_VALID_USER.name())
                .message(CustomErrorCode.NOT_VALID_USER.getMessage())
                .build()));
    }

    private String convertObjectToJson(Object object) throws JsonProcessingException {
        return objectMapper.writeValueAsString(object);
    }
}
