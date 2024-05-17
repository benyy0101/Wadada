package org.api.wadada.marathon.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.api.wadada.config.RabbitMQConfig;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.api.wadada.marathon.entity.Member;
import org.api.wadada.util.DynamicRabbitMqConfigurer;
import org.geolatte.geom.M;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

import static org.api.wadada.marathon.dto.GameMessage.MARATHON_INFO_SEND;

@AllArgsConstructor
@Service
@Getter
@Builder
public class MarathonRoomManager {
    private Map<String, MemberInfo> memberInfoMap = new HashMap<>();
    private final List<MarathonRoomDto> rooms;
    private static final int MAX_ROOMS = 40;
    private int curRooms = -1;
    private int curPerson = -1;

    private int REAL_max_Person;
    private int REAL_cur_Person;
    private SimpMessagingTemplate messagingTemplate;
    private ExecutorService executor = Executors.newCachedThreadPool();
    private DynamicRabbitMqConfigurer dynamicRabbitMqConfigurer;


    private  String queueName;
    private  String exchangeName;
    private  String routingKey;

    public MarathonRoomManager() {
        this.rooms = new ArrayList<>(MAX_ROOMS);
        for (int i = 0; i < MAX_ROOMS; i++) {
            rooms.add(null);
        }
    }

    public MarathonRoomManager(SimpMessagingTemplate messagingTemplate,RabbitMQConfig rabbitMQConfig,DynamicRabbitMqConfigurer dynamicRabbitMqConfigurer) {
        this.messagingTemplate = messagingTemplate;
        this.dynamicRabbitMqConfigurer = dynamicRabbitMqConfigurer;
        this.queueName = rabbitMQConfig.getQueueName();
        this.exchangeName = rabbitMQConfig.getExchangeName();
        this.routingKey = rabbitMQConfig.getRoutingKey();
        this.rooms = new ArrayList<>(MAX_ROOMS);
        for (int i = 0; i < MAX_ROOMS; i++) {
            rooms.add(null);
        }
    }

    private int addRoom(MarathonRoomDto room) throws Exception {
        rooms.set(++curRooms, room);

        System.out.println("queueName = " + queueName+(curRooms+1));
        System.out.println("exchangeName = " + exchangeName);
        System.out.println("routingKey = " + routingKey+(curRooms+1));
        System.out.println("curRooms = " + curRooms);
        dynamicRabbitMqConfigurer.bindExistingQueueToExchange(queueName+(curRooms+1),exchangeName,routingKey+(curRooms+1));

        return curRooms;
    }

    public void removeRoom(int index) {
        if (index < 0 || index >= MAX_ROOMS) {
            throw new IndexOutOfBoundsException("잘못된 방 인덱스");
        }
        Optional<Integer> roomIndex = getRoomIndex(index);
        if (roomIndex.isEmpty()) {
            throw new RestApiException(CustomErrorCode.NO_ROOM);
        } else {
            curRooms--;
            rooms.set(roomIndex.get(), null);
        }
    }

    public Optional<Integer> getRoomIndex(int index) {
        for (int i = 0; i <= curRooms; i++) {
            if (rooms.get(i).getRoomSeq() == index) {
                return Optional.of(i);
            }
        }
        return Optional.empty();
    }


    public boolean InsertMember(MemberInfo memberInfo) throws Exception {
        if(memberInfoMap.containsKey(memberInfo.getMemberName()))
            return false;

        //현재 방(채널)에 100명이 찼으면
        if (++curPerson % 100 == 0) {
            //방 만들고
            curRooms = addRoom(new MarathonRoomDto());
            //해당 방에 멤버 넣기
            rooms.get(curRooms).insertMember(memberInfo);
            memberInfoMap.put(memberInfo.getMemberName(),memberInfo);
            //방 인덱스 1 증가
        }
        //현재 방(채널)에 100명이 안찼으면
        else {
            //현재 방에 멤버 넣기
            rooms.get(getCurRooms()).insertMember(memberInfo);
            memberInfoMap.put(memberInfo.getMemberName(),memberInfo);
        }
        REAL_max_Person++;
        return true;
    }

    public void increaseRealCurPerson() {
        this.REAL_cur_Person++;
    }

    public void sendMessage() {
        String message = GameMessage.GAME_START.toJson();
        for (int i = 0; i <= curRooms; i++) {
            messagingTemplate.convertAndSend("/sub/attend/" + i, message);
        }
    }
    public void sendStartMessage() {
        String message = GameMessage.GAME_START_INFO_REQUEST.toJson();
        System.out.println("curRooms = " + curRooms);
        for (int i = 0; i <= curRooms; i++) {
            messagingTemplate.convertAndSend("/sub/attend/" + i, message);
        }
    }
    public void sendEndMessage() {
        for (int i = 0; i <= curRooms; i++) {
//            String message = GameMessage.MARATHON_INFO_SEND.toJson();
//            message += rooms.get(i).getSentence();
            messagingTemplate.convertAndSend("/sub/attend/" + i, rooms.get(i).getSentence());
        }
    }
    public void sortMember() {

        List<MemberInfo> allList = memberInfoMap.values().stream().collect(Collectors.toList());



        // Collections.sort 메서드와 커스텀 Comparator를 사용하여 List<MemberInfo> 정렬
        Collections.sort(allList, new Comparator<MemberInfo>() {
            @Override
            public int compare(MemberInfo o1, MemberInfo o2) {
                // memberSeq를 기준으로 오름차순 정렬
                if (o1.getDist() == o2.getDist())
                    return o1.getTime() - o2.getTime();
                return o2.getDist() - o1.getDist();
            }
        });

        for (int i = 0; i < allList.size(); i++) {
            MemberInfo curMemberInfo = allList.get(i);
            curMemberInfo.resetRankings();
            int start = i - 2 >= 0 ? i - 2 : 0;
            int end = i + 2 < allList.size() ? i + 2 : allList.size() - 1;
            curMemberInfo.setMemberRank(i+1);
            for (int k = start; k <= end; k++) {
                curMemberInfo.getRankings().add(new MarathonRankingInfoDetailDto(curMemberInfo.getImage(), curMemberInfo.getMemberName(), curMemberInfo.getDist(), curMemberInfo.getTime(),k+1));
            }
        }

    }

    public MemberInfo FindMember(String MemberName) {
        System.out.println("memberInfoMap = " + memberInfoMap.get(MemberName));
        return memberInfoMap.get(MemberName);
    }


    public void makeSentence(){
        for(int i=0; i<=curRooms; i++){
            rooms.get(i).makeSentence();
        }
    }


}
