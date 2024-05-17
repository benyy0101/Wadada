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
    private Map<String,MemberInfo> marathonMap;
    private SimpMessagingTemplate messagingTemplate;
    private int curMember = -1;
    private String sentence;

    public void resetSentence(){
        sentence = null;
    }
    public void makeSentence() {
        resetSentence();

        // 새로운 Map 생성
        Map<Integer, Object> resultMap = new HashMap<>();
        for (MemberInfo memberInfo : marathonMap.values()) {
            resultMap.put(memberInfo.getMemberSeq(), memberInfo.getRankings());
        }

        // ObjectMapper를 사용하여 Map을 JSON 문자열로 변환
        ObjectMapper mapper = new ObjectMapper();
        try {
            // resultMap을 JSON 문자열로 변환
            String jsonResult = mapper.writeValueAsString(resultMap);

            // 최종 JSON 객체를 위한 새로운 Map 생성
            Map<String, Object> finalMap = new HashMap<>();
            finalMap.put("result", jsonResult); // resultMap의 결과를 'result' 키에 할당
            finalMap.put("action", "2"); // 'action' 키에 "2" 값을 할당

            // 최종 Map을 JSON 문자열로 변환
            sentence = mapper.writeValueAsString(finalMap);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //    public void makeSentence(){
//        resetSentence();
//
//        // 새로운 Map 생성
//        Map<Integer, Object> resultMap = new HashMap<>();
//        for (MemberInfo memberInfo : marathonMap.values()) {
//            resultMap.put(memberInfo.getMemberSeq(), memberInfo.getRankings());
//        }
//
//        // ObjectMapper를 사용하여 Map을 JSON 문자열로 변환
//        ObjectMapper mapper = new ObjectMapper();
//        try {
//            String jsonResult = mapper.writeValueAsString(resultMap);
//            sentence = jsonResult;
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//    }




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
        if(marathonMap.containsKey(memberInfo.getMemberName())){
            return false;
        }
        marathonMap.put(memberInfo.getMemberName(),memberInfo);
        curMember++;
        return true;
    }

    public boolean updateMember(MemberInfo memberInfo){
        if(!marathonMap.containsKey(memberInfo.getMemberName())){
            return false;
        }
        marathonMap.put(memberInfo.getMemberName(),memberInfo);
        return true;
    }
    public void removeAllMembers(){
      this.marathonMap = new HashMap<>(MAX_ROOM_SIZE);
    }



}
