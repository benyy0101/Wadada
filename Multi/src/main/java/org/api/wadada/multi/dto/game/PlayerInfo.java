package org.api.wadada.multi.dto.game;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class PlayerInfo {
    private int dist;
    private int time;
    private String name;

    private boolean isManager;

}
