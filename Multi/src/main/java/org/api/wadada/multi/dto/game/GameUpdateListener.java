package org.api.wadada.multi.dto.game;

import org.api.wadada.multi.dto.GameRoomDto;

public interface GameUpdateListener {
    void onGameUpdate(GameRoomDto game);
}
