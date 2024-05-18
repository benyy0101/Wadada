package org.api.wadada.marathon.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import org.api.wadada.config.RabbitMQConfig;
import org.api.wadada.util.DynamicRabbitMqConfigurer;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@AllArgsConstructor
@Service
@Getter
@Builder
public class MarathonGameManager {
    private MarathonRoomManager marathonRoomManager;
    private final SimpMessagingTemplate simpMessagingTemplate;
    private final DynamicRabbitMqConfigurer dynamicRabbitMqConfigurer;
    private final RabbitMQConfig rabbitMQConfig;
    //private final int MarathonGameSize = 1;
    public void CreateNewMarathonGame(LocalDateTime start, LocalDateTime end,int marathonSeq){
        this.marathonRoomManager = new MarathonRoomManager(simpMessagingTemplate,rabbitMQConfig,dynamicRabbitMqConfigurer,start,end,marathonSeq);
    }
    public MarathonRoomManager GetMarathonRoomManager(){
        return this.marathonRoomManager;
    }

    public void RemoveMarathonGame(){
        this.marathonRoomManager = new MarathonRoomManager();
    }





}
