package org.api.wadada.marathon.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.api.wadada.marathon.entity.Member;
import org.geolatte.geom.M;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

@AllArgsConstructor
@Service
@Getter
@Builder
public class MarathonRoomManager {
    private Map<Integer, MemberInfo> memberInfoMap = new HashMap<>();
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
        //현재 방(채널)에 100명이 찼으면
        if (++curPerson % 100 == 0) {
            //방 만들고
            curRooms = addRoom(new MarathonRoomDto());
            //해당 방에 멤버 넣기
            rooms.get(curRooms).insertMember(memberInfo);
            memberInfoMap.put(memberInfo.getMemberSeq(),memberInfo);
            //방 인덱스 1 증가
        }
        //현재 방(채널)에 100명이 안찼으면
        else {
            //현재 방에 멤버 넣기
            rooms.get(getCurRooms()).insertMember(memberInfo);
            memberInfoMap.put(memberInfo.getMemberSeq(),memberInfo);
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

    public void sendEndMessage() {
        for (int i = 0; i <= curRooms; i++) {
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
            for (int k = start; k <= end; k++) {
                allList.get(i).getRankings().add(new MarathonRankingInfoDetailDto(curMemberInfo.getImage(), curMemberInfo.getMemberName(), curMemberInfo.getDist(), curMemberInfo.getTime()));
            }
        }

    }

    public MemberInfo FindMember(int MemberSeq) {
        return memberInfoMap.get(MemberSeq);
    }


    public void makeSentence(){
        for(int i=0; i<=curRooms; i++){
            rooms.get(i).makeSentence();
        }
    }
}
