package org.api.wadada.marathon.dto;

import lombok.*;

import java.util.HashMap;
import java.util.Map;

@Getter
public class MarathonRoomDto {

    private int RoomSeq;
    private final int MAX_ROOM_SIZE = 5000;
    private Map<Integer,MemberInfo> marathonMap;
    public MarathonRoomDto(){
        marathonMap  = new HashMap<>(MAX_ROOM_SIZE);
    }
    public MarathonRoomDto(int roomSeq){
        marathonMap  = new HashMap<>(MAX_ROOM_SIZE);
        this.RoomSeq = roomSeq;
    }
    public boolean insertMember(MemberInfo memberInfo){
        if(marathonMap.containsKey(memberInfo.getMemberSeq())){
            System.out.println("marathonMap = " + marathonMap.containsKey(memberInfo.getMemberSeq()));
            System.out.println("memberInfo = " + memberInfo.getMemberSeq());
            return false;
        }
        marathonMap.put(memberInfo.getMemberSeq(),memberInfo);
        return true;
    }
    public void removeAllMembers(){
      this.marathonMap = new HashMap<>(MAX_ROOM_SIZE);
    }
}
