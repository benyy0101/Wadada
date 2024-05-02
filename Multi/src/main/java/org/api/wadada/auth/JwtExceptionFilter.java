package org.api.wadada.auth;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.response.ErrorResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@RequiredArgsConstructor
@Slf4j
public class JwtExceptionFilter extends OncePerRequestFilter {

    private final ObjectMapper objectMapper;

    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain chain) throws ServletException, IOException {
        try {
            System.out.println(req.getRequestURI());
            chain.doFilter(req, res);
        } catch (ExpiredJwtException e){
            log.info("expired jwt token, redirect to auth/reissue");
            res.setHeader("Access-Control-Allow-Origin", "*");
            res.sendRedirect("/Wadada/auth/reissue");
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
