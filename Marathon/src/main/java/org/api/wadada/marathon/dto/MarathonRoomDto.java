package org.api.wadada.marathon.dto;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.*;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

@Getter
public class MarathonRoomDto {

    private int RoomSeq;
    private final int MAX_ROOM_SIZE = 100;
    private Map<Integer,MemberInfo> marathonMap;
    private SimpMessagingTemplate messagingTemplate;
    private int curMember = -1;
    private String sentence;

    public void resetSentence(){
        sentence = null;
    }
    public void makeSentence(){
        resetSentence();

        // 새로운 Map 생성
        Map<Integer, Object> resultMap = new HashMap<>();
        for (MemberInfo memberInfo : marathonMap.values()) {
            resultMap.put(memberInfo.getMemberSeq(), memberInfo.getRankings());
        }

        // ObjectMapper를 사용하여 Map을 JSON 문자열로 변환
        ObjectMapper mapper = new ObjectMapper();
        try {
            String jsonResult = mapper.writeValueAsString(resultMap);
            sentence = jsonResult;
        } catch (Exception e) {
            e.printStackTrace();
        }

    }




    public MarathonRoomDto(){
        marathonMap  = new HashMap<>(MAX_ROOM_SIZE);
    }
    public MarathonRoomDto(int roomSeq){
        marathonMap  = new HashMap<>(MAX_ROOM_SIZE);
        this.RoomSeq = roomSeq;
    }
    public MarathonRoomDto(SimpMessagingTemplate simpMessagingTemplate){
        marathonMap  = new HashMap<>(MAX_ROOM_SIZE);
        this.messagingTemplate = simpMessagingTemplate;
    }
    public boolean insertMember(MemberInfo memberInfo){
        if(marathonMap.containsKey(memberInfo.getMemberSeq())){
            return false;
        }
        marathonMap.put(memberInfo.getMemberSeq(),memberInfo);
        curMember++;
        return true;
    }

    public boolean updateMember(MemberInfo memberInfo){
        if(!marathonMap.containsKey(memberInfo.getMemberSeq())){
            return false;
        }
        marathonMap.put(memberInfo.getMemberSeq(),memberInfo);
        return true;
    }
    public void removeAllMembers(){
      this.marathonMap = new HashMap<>(MAX_ROOM_SIZE);
    }



}
