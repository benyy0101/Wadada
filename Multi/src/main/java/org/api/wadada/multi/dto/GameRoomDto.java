package org.api.wadada.multi.dto;

import lombok.*;
import org.api.wadada.multi.dto.game.GameUpdateListener;
import org.api.wadada.multi.dto.game.PlayerInfo;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.atomic.AtomicInteger;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class GameRoomDto {

    @Setter
    private int roomIdx;
    private int MaxPeople;
    private int roomSeq;
    @Setter
    private int curPeople;

    // curPeople 값을 증가시키는 메서드


    // curPeople 값을 가져오는 메서드
    @Setter
    private List<GameUpdateListener> listeners;

    private ConcurrentMap<String,PlayerInfo> playerInfo;

    public void addMember(PlayerInfo member) {
        if (playerInfo.containsKey(member.getName())) {
            throw new IllegalStateException("방에 해당 멤버가 존재합니다");
        }
        playerInfo.put(member.getName(), member);

    }

    public boolean removeMember(String memberName) {
        if (!playerInfo.containsKey(memberName)) {
            throw new IllegalStateException("방에 삭제할 멤버가 존재하지 않습니다");
        }
        if(playerInfo.get(memberName).isManager()){
            return true;
        }
        playerInfo.remove(memberName);
        return false;
    }
    public List<PlayerInfo> getMemberList(){
        if(this.playerInfo.isEmpty()){
            throw new RuntimeException("방에 멤버가 없습니다");
        }
        return new ArrayList<>(this.playerInfo.values());
    }
    public synchronized void increasedMember(){
        this.curPeople++;
        notifyAll();
    }
    public int getMemberCount() {
        return curPeople; // AtomicInteger의 get() 메서드를 사용하여 int 값을 반환
    }


    public void removeAllMembers() {
        playerInfo.clear();
    }
    public void setCurPeople(int curPeople) {
        this.curPeople = curPeople;
        notifyAll();
    }

    public void addUpdateListener(GameUpdateListener listener) {
        listeners.add(listener);
    }

    private void notifyUpdateListeners() {
        for (GameUpdateListener listener : listeners) {
            listener.onGameUpdate(this);
        }
    }

    public void updatePlayerInfo(String memberId, int dist, int time){
        PlayerInfo info = this.playerInfo.get(memberId);
        info.setDist(dist);
        info.setTime(time);
        this.playerInfo.put(memberId,info);
    }

}
