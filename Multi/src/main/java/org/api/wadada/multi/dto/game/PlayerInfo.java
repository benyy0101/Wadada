package org.api.wadada.multi.dto.game;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class PlayerInfo implements Comparable<PlayerInfo> {
    @Setter
    private int dist;
    @Setter
    private int time;
    private String name;
    private boolean isManager;
    private String profileImage;
    private String memberId;

    @Override
    public int compareTo(PlayerInfo o) {
        int distCompare = Integer.compare(this.dist, o.dist);
        if (distCompare == 0) {
            return Integer.compare(this.time, o.time);
        }
        return -distCompare;
    }
}
