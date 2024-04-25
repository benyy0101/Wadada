package org.api.wadada.auth;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.error.errorcode.CommonErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.springframework.web.servlet.HandlerInterceptor;

@Slf4j
public class ReferrerCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String referer = request.getHeader("Referer");
        String host = request.getHeader("Host");
        log.info("referer : {}", referer);
        log.info("host : {}", host);
        if (referer == null || (!referer.contains(host) && !referer.contains("localhost:3000"))) {
            throw new RestApiException(CommonErrorCode.WRONG_REQUEST, "referer 헤더 정보가 설정되어있지 않거나 잘못되었습니다");
        }
        return true;
    }
}
