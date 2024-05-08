package org.api.wadada.multi.dto;

import lombok.*;
import org.api.wadada.multi.dto.game.GameUpdateListener;
import org.api.wadada.multi.dto.game.PlayerInfo;
import org.api.wadada.multi.dto.res.RoomMemberRes;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentMap;

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
    private List<GameUpdateListener> listeners = new ArrayList<>();

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
    public int getMemberCount(){
        return this.playerInfo.size();
    }

    public void removeAllMembers() {
        playerInfo.clear();
    }
    public void setCurPeople(int curPeople) {
        this.curPeople = curPeople;
        notifyUpdateListeners();
    }

    public void addUpdateListener(GameUpdateListener listener) {
        listeners.add(listener);
    }

    private void notifyUpdateListeners() {
        for (GameUpdateListener listener : listeners) {
            listener.onGameUpdate(this);
        }
    }

}
