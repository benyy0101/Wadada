package org.api.wadada.marathon.interceptor;

import com.rabbitmq.client.Channel;
import lombok.AllArgsConstructor;
import lombok.Value;
import org.api.wadada.config.RabbitMQConfig;
import org.api.wadada.marathon.dto.MarathonGameManager;
import org.api.wadada.marathon.dto.MarathonRoomManager;
import org.api.wadada.marathon.dto.MemberInfo;
import org.api.wadada.marathon.dto.MessageDto;
import org.api.wadada.marathon.dto.req.RabbitRequestDataReq;
import org.api.wadada.marathon.dto.req.RequestDataReq;
import org.springframework.amqp.rabbit.annotation.RabbitHandler;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.support.AmqpHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

import java.security.Principal;
import java.util.LinkedHashMap;

@Component
@AllArgsConstructor
public class DefaultListener {
    //, Channel channel, @Header(AmqpHeaders.DELIVERY_TAG) long tag
    private final MarathonGameManager marathonGameManager;

//    @RabbitListener(queues = "${rabbitmq.queue.name}")
//    @RabbitHandler
//    public void receiveMessage(MessageDto message) {
//        try {
//            System.out.println("message = " + message);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//@RabbitListener(queues = "${rabbitmq.marathon1.name}")
    @RabbitListener(queues = "${rabbitmq.marathon1.name}")
    @RabbitHandler
    public void marathon1(RequestDataReq requestDataReq) {
        try {
            System.out.println("requestDataReq = " + requestDataReq.toString());
            MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();
            MemberInfo memberInfo = marathonRoomManager.FindMember(requestDataReq.getUserName());
            memberInfo.setDist(requestDataReq.getUserDist());
            memberInfo.setTime(requestDataReq.getUserTime());
            if(marathonRoomManager.getRooms().get(memberInfo.getCurRoom()).updateMember(memberInfo)){
                System.out.println("업데이트 성공");
            }
            else{
                System.out.println("실패");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @RabbitListener(queues = "${rabbitmq.marathon2.name}")
    @RabbitHandler
    public void marathon2(RequestDataReq requestDataReq) {
        try {
            MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();
            MemberInfo memberInfo = marathonRoomManager.FindMember(requestDataReq.getUserName());
            if(marathonRoomManager.getRooms().get(memberInfo.getCurRoom()).updateMember(memberInfo)){
                System.out.println("업데이트 성공");
            }
            else{
                System.out.println("실패");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @RabbitListener(queues = "${rabbitmq.marathon3.name}")
    @RabbitHandler
    public void marathon3(RequestDataReq requestDataReq) {
        try {
            MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();
            MemberInfo memberInfo = marathonRoomManager.FindMember(requestDataReq.getUserName());
            if(marathonRoomManager.getRooms().get(memberInfo.getCurRoom()).updateMember(memberInfo)){
                System.out.println("업데이트 성공");
            }
            else{
                System.out.println("실패");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}