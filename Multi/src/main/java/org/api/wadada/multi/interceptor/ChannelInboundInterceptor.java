package org.api.wadada.multi.interceptor;

import jakarta.servlet.ServletRequest;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.auth.JwtTokenProvider;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.messaging.Message;
import org.springframework.transaction.annotation.Transactional;

import java.security.Principal;
import java.util.Map;
import java.util.Objects;


@Slf4j
@RequiredArgsConstructor
@Component
public class ChannelInboundInterceptor  implements ChannelInterceptor {

    private final JwtTokenProvider jwtTokenProvider;

    /**
     * 메세지를 보내기 전에 실행되는 interceptor 메소드
     *
     * @param message 전송될 메시지. 이 메시지의 header에는 JWT Token이 포함되어 있어야 함
     * @param channel 메시지가 전송될 채널
     * @return 수정된 메시지를 반환 (사용자 인증 정보가 추가된 페이지)
     */
    @Transactional(readOnly = true)
    public Message<?> preSend(Message<?> message, MessageChannel channel){
        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);
        log.info(accessor.toString());
        StompCommand command = accessor.getCommand();

        if(StompCommand.CONNECT.equals(command)){
            String token = Objects.requireNonNull(accessor.getFirstNativeHeader("Authorization")).substring(7);
            log.info(token);
            if (jwtTokenProvider.validateToken(token)) {
                Authentication authentication = jwtTokenProvider.getAuthentication(token);
                log.info(authentication.getPrincipal().toString());
                accessor.setUser(authentication);
            }
        }
        if (StompCommand.SUBSCRIBE.equals(command)) {
            Principal principal = accessor.getUser();
            setValue(accessor,"userName",principal.getName());
        }


        return message;
    }
    private void setValue(StompHeaderAccessor accessor, String key, Object value) {
        Map<String, Object> sessionAttributes = getSessionAttributes(accessor);
        sessionAttributes.put(key, value);
    }

    private Map<String, Object> getSessionAttributes(StompHeaderAccessor accessor) {
        Map<String, Object> sessionAttributes = accessor.getSessionAttributes();
        return sessionAttributes;
    }

}
