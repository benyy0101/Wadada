package org.api.wadada.util;

import org.api.wadada.multi.dto.game.PlayerInfo;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.*;

@Component
public class GameSessionManager {

    private final Map<String, GameSession> sessions = new ConcurrentHashMap<>();
    private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

    public void registerPlayer(String gameSessionId, PlayerInfo playerInfo) {
        GameSession session = sessions.computeIfAbsent(gameSessionId, k -> createNewSession(gameSessionId));
        session.registerPlayer(playerInfo);
    }

    private GameSession createNewSession(String gameSessionId) {
        GameSession newSession = new GameSession(gameSessionId, 6); // 여기서 6은 최대 참가자 수입니다.
        Runnable timeoutTask = () -> {
            if (!newSession.isGameStarted()) {
                newSession.startGame();
            }
        };
        scheduler.schedule(timeoutTask, 30, TimeUnit.SECONDS);
        return newSession;
    }

    // GameSession 클래스와 PlayerInfo 클래스는 상황에 맞게 구현
}


