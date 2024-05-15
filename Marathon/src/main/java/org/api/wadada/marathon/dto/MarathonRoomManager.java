package org.api.wadada.marathon.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@AllArgsConstructor
@Service
@Getter
@Builder
public class MarathonRoomManager {
    private Map<Integer,MemberInfo> memberInfoMap = new HashMap<>();
    private final List<MarathonRoomDto> rooms;
    private static final int MAX_ROOMS = 40;
    private int curRooms = -1;
    private int curPerson = -1;

    private int REAL_max_Person;
    private int REAL_cur_Person;
    private SimpMessagingTemplate messagingTemplate;
    private ExecutorService executor = Executors.newCachedThreadPool();

    public MarathonRoomManager() {
        this.rooms = new ArrayList<>(MAX_ROOMS);
        for (int i = 0; i < MAX_ROOMS; i++) {
            rooms.add(null);
        }
    }

    public MarathonRoomManager(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
        this.rooms = new ArrayList<>(MAX_ROOMS);
        for (int i = 0; i < MAX_ROOMS; i++) {
            rooms.add(null);
        }
    }
    private int addRoom(MarathonRoomDto room) throws Exception {
        rooms.set(++curRooms, room);
        return curRooms;
    }

    public void removeRoom(int index) {
        if (index < 0 || index >= MAX_ROOMS) {
            throw new IndexOutOfBoundsException("잘못된 방 인덱스");
        }
        Optional<Integer> roomIndex = getRoomIndex(index);
        if(roomIndex.isEmpty()){
            throw new RestApiException(CustomErrorCode.NO_ROOM);
        }
        else {
            curRooms--;
            rooms.set(roomIndex.get(), null);
        }
    }

    public Optional<Integer> getRoomIndex(int index) {
        for (int i=0; i<=curRooms; i++){
            if (rooms.get(i).getRoomSeq() == index) {
                return Optional.of(i);
            }
        }
        return Optional.empty();
    }


    public boolean InsertMember(MemberInfo memberInfo) throws Exception {
        //현재 방(채널)에 100명이 찼으면
        if(++curPerson %100 == 0){
            //방 만들고
            curRooms = addRoom(new MarathonRoomDto());
            //해당 방에 멤버 넣기
            rooms.get(curRooms).insertMember(memberInfo);
            //방 인덱스 1 증가
            curRooms++;
        }
        //현재 방(채널)에 100명이 안찼으면
        else{
            //현재 방에 멤버 넣기
            rooms.get(getCurRooms()).insertMember(memberInfo);
        }
        REAL_max_Person++;
        memberInfo.updatememberLocation(curRooms,curPerson);
        memberInfoMap.put(memberInfo.getMemberSeq(),memberInfo);
        return true;
    }

    public MemberInfo FindMember(Integer MemberSeq){
        return memberInfoMap.get(MemberSeq);
    }

    public void increaseRealCurPerson(){
        this.REAL_cur_Person++;
    }
    public void sendMessage () {
        String message = GameMessage.GAME_START.toJson();
        for (int i = 0; i <= curRooms; i++) {
            messagingTemplate.convertAndSend("/sub/attend/" + i, message);
        }
    }
}
