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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
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

    private LocalDateTime startTime;
    private LocalDateTime endTime;

    private boolean isStarted;

    private int marathonSeq;

    public MarathonRoomManager() {
        this.rooms = new ArrayList<>(MAX_ROOMS);
        for (int i = 0; i < MAX_ROOMS; i++) {
            rooms.add(null);
        }
    }

    public MarathonRoomManager(SimpMessagingTemplate messagingTemplate,RabbitMQConfig rabbitMQConfig,DynamicRabbitMqConfigurer dynamicRabbitMqConfigurer,LocalDateTime startTime, LocalDateTime endTime,int marathonSeq) {
        this.messagingTemplate = messagingTemplate;
        this.dynamicRabbitMqConfigurer = dynamicRabbitMqConfigurer;
        this.queueName = rabbitMQConfig.getQueueName();
        this.exchangeName = rabbitMQConfig.getExchangeName();
        this.routingKey = rabbitMQConfig.getRoutingKey();
        this.startTime = startTime;
        this.endTime = endTime;
        this.marathonSeq = marathonSeq;
        this.rooms = new ArrayList<>(MAX_ROOMS);
        for (int i = 0; i < MAX_ROOMS; i++) {
            rooms.add(null);
        }
    }

    private int addRoom(MarathonRoomDto room) throws Exception {
        rooms.set(++curRooms, room);
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
            curRooms++;
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

    public synchronized void increaseRealCurPerson() {
        this.REAL_cur_Person++;
        notifyAll(); // 현재 객체(this, 즉 marathonRoomManager)의 모니터에 대해 notifyAll 호출
    }

    public void sendMessage() {
        String message = GameMessage.GAME_START.toJson();
        isStarted = true;
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
    public void sendGameRunningMessage() {
        for (int i = 0; i <= curRooms; i++) {
//            String message = GameMessage.MARATHON_INFO_SEND.toJson();
//            message += rooms.get(i).getSentence();
            messagingTemplate.convertAndSend("/sub/attend/" + i, rooms.get(i).getSentence());
        }
    }
    public void sendGameEndMessage() {
        String message = GameMessage.GAME_START.toJson();
        isStarted = true;
        for (int i = 0; i <= curRooms; i++) {
            messagingTemplate.convertAndSend("/sub/attend/" + i, message);
        }
    }
    public void sortMember() {

        List<MemberInfo> allList = memberInfoMap.values().stream().collect(Collectors.toList());



        // Collections.sort 메서드와 커스텀 Comparator를 사용하여 List<MemberInfo> 정렬
        // 람다 표현식 사용
        Collections.sort(allList, (o1, o2) -> {
            // 거리 내림차순
            if (o1.getDist() != o2.getDist()) {
                return Integer.compare(o2.getDist(), o1.getDist());
            }
            // 시간이 같으면 시간 오름차순
            return Integer.compare(o1.getTime(), o2.getTime());
        });

        for (int i = 0; i < allList.size(); i++) {
            MemberInfo curMemberInfo = allList.get(i);
            curMemberInfo.resetRankings(); // 랭킹 초기화

            int start = Math.max(i - 2, 0); // 시작 인덱스
            int end = Math.min(i + 2, allList.size() - 1); // 종료 인덱스

            curMemberInfo.setMemberRank(i + 1); // 현재 멤버의 랭크 설정

            // 디버깅을 위한 출력문 추가
            System.out.println("Member: " + curMemberInfo.getMemberName() + ", Rank: " + (i + 1));
            System.out.println("Rankings from " + start + " to " + end);

            for (int k = start; k <= end; k++) {
                MemberInfo neighborMemberInfo = allList.get(k);
                curMemberInfo.getRankings().add(new MarathonRankingInfoDetailDto(
                        neighborMemberInfo.getImage(),
                        neighborMemberInfo.getMemberName(),
                        neighborMemberInfo.getDist(),
                        neighborMemberInfo.getTime(),
                        k + 1
                ));
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
