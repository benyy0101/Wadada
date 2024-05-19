package org.api.wadada.marathon.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.config.RabbitMQConfig;
import org.api.wadada.marathon.dto.MarathonGameManager;
import org.api.wadada.marathon.dto.MarathonRoomManager;
import org.api.wadada.marathon.dto.MessageDto;
import org.api.wadada.marathon.dto.req.RabbitRequestDataReq;
import org.api.wadada.marathon.dto.req.RequestDataReq;
import org.api.wadada.marathon.interceptor.DefaultListener;
import org.api.wadada.util.DynamicRabbitMqConfigurer;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.security.Principal;

@Slf4j
@RequiredArgsConstructor
@Service
public class MessageService {


    private final RabbitMQConfig rabbitMQConfig;

    private final RabbitTemplate rabbitTemplate;

    private final DefaultListener defaultListener;
    private final DynamicRabbitMqConfigurer dynamicRabbitMqConfigurer;

    private final MarathonGameManager marathonGameManager;
    /**
     * Queue로 메시지를 발행
     *
     * @param messageDto 발행할 메시지의 DTO 객체
     */
    public void sendMessage(MessageDto messageDto) {
        log.info("message sent: {}", messageDto.toString());
        rabbitTemplate.convertAndSend(rabbitMQConfig.getExchangeName(), rabbitMQConfig.getRoutingKey(), messageDto);
    }
    public void sendMarathonMessage(RequestDataReq requestDataReq) {

        System.out.println("exchangeName = " + rabbitMQConfig.getExchangeName());
        System.out.println("routingKey = " + rabbitMQConfig.getRoutingKey()+(requestDataReq.getRoomSeq()+1));

        rabbitTemplate.convertAndSend(rabbitMQConfig.getExchangeName(), rabbitMQConfig.getRoutingKey()+(requestDataReq.getRoomSeq()+1), requestDataReq);
    }

    /**
     * Queue에서 메시지를 구독
     *
     * @param messageDto 구독한 메시지를 담고 있는 MessageDto 객체
     */
//    @RabbitListener(queues = "${rabbitmq.queue.name}")
//    public void receiveMessage(MessageDto messageDto) {
//        log.info("Received message: {}", messageDto.toString());
//    }
}