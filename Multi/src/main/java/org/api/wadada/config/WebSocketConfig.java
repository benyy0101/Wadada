package org.api.wadada.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.multi.interceptor.ChannelInboundInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.Message;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.messaging.SessionConnectEvent;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

@Slf4j
@Configuration
@EnableWebSocketMessageBroker
@RequiredArgsConstructor
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    private final ChannelInboundInterceptor channelInboundInterceptor;

    //메세지 브로커 설정
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        //구독한 사람들에게 전송(방에 있는 사람들)
        config.setApplicationDestinationPrefixes("/pub");
        //채널 입장
        config.enableSimpleBroker("/sub");
    }


    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry){
        registry.addEndpoint("/Multi/ws").setAllowedOrigins("*").withSockJS();
        // withSockJs() 함수를 통해 ws, wss로 socket을 연결하는 것이 아닌 http, https로 socket을 연결하도록 바꾸어줌
    }

    // 연결 성공 체크
    @EventListener
    public void ConnectEvent(SessionConnectEvent sessionConnectEvent) {
        log.info("연결 성공");
    }

    // 연결 끊김 체크
    @EventListener
    public void onDisconnectEvent(SessionDisconnectEvent sessionDisconnectEvent) {

    Message<byte[]> message = sessionDisconnectEvent.getMessage();
    StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
    StompCommand command = accessor.getCommand();
    System.out.println(sessionDisconnectEvent);
    System.out.println("연결 끊어짐!");

    }


    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(channelInboundInterceptor);
    }


}
