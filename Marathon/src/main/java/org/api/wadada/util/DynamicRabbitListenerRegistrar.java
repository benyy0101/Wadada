//package org.api.wadada.util;
//
//import jakarta.annotation.PostConstruct;
//import lombok.AllArgsConstructor;
//import org.api.wadada.marathon.dto.MarathonGameManager;
//import org.api.wadada.marathon.dto.MarathonRoomManager;
//import org.api.wadada.marathon.dto.MemberInfo;
//import org.api.wadada.marathon.dto.MessageDto;
//import org.springframework.amqp.rabbit.annotation.RabbitHandler;
//import org.springframework.amqp.rabbit.config.SimpleRabbitListenerEndpoint;
//import org.springframework.amqp.rabbit.connection.ConnectionFactory;
//import org.springframework.amqp.rabbit.listener.DirectMessageListenerContainer;
//import org.springframework.amqp.rabbit.listener.RabbitListenerContainerFactory;
//import org.springframework.amqp.rabbit.listener.SimpleMessageListenerContainer;
//import org.springframework.amqp.rabbit.listener.adapter.MessageListenerAdapter;
//import org.springframework.amqp.rabbit.listener.RabbitListenerEndpointRegistry;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Qualifier;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.stereotype.Component;
//
//
//@Configuration
//@AllArgsConstructor
//public class DynamicRabbitListenerRegistrar {
//
//    @Qualifier("RabbitListenerEndpointRegistry")
//    private final RabbitListenerEndpointRegistry registry;
//
//    private final MarathonGameManager marathonGameManager;
//
//    private final RabbitListenerContainerFactory<DirectMessageListenerContainer> rabbitListenerContainerFactory;
//    @PostConstruct
//    public void init() {
//        for (int i = 1; i <= 3; i++) {
//            registerListener(i);
//        }
//    }
//
//    private void registerListener(int id) {
//        SimpleRabbitListenerEndpoint endpoint = new SimpleRabbitListenerEndpoint();
//        endpoint.setId("marathonListener" + id);
//        endpoint.setQueueNames("marathon" + id);
//
//        // MessageListenerAdapter를 사용하여 메시지 처리 로직을 설정
//        endpoint.setMessageListener(new MessageListenerAdapter(new Object() {
//            // 실제 메시지 처리 로직을 수행하는 메서드
//            public void handleMessage(MessageDto message) {
//                try {
//                    MarathonRoomManager marathonRoomManager = marathonGameManager.GetMarathonRoomManager();
//                    MemberInfo memberInfo = marathonRoomManager.FindMember(id);
//                    if(marathonRoomManager.getRooms().get(memberInfo.getCurRoom()).updateMember(memberInfo)){
//                        System.out.println("업데이트 성공");
//                    } else {
//                        System.out.println("실패");
//                    }
//                } catch (Exception e) {
//                    e.printStackTrace();
//                }
//            }
//        }, "handleMessage"));
//
//        registry.registerListenerContainer(endpoint, rabbitListenerContainerFactory);
//    }
//}
