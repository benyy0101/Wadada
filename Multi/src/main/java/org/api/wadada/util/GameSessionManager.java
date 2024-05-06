package org.api.wadada.util;

import java.util.concurrent.CountDownLatch;

class GameSession {
    private final String id;
    private final CountDownLatch latch;
    private volatile boolean gameStarted = false;

    public GameSession(String id, int playerCount) {
        this.id = id;
        this.latch = new CountDownLatch(playerCount);
    }

    public void registerPlayer(PlayerInfo playerInfo) {
        // 플레이어 등록 로직
        latch.countDown();
        if (latch.getCount() == 0) {
            startGame();
        }
    }

    public synchronized void startGame() {
        if (!gameStarted) {
            gameStarted = true;
            // 게임 시작 로직
        }
    }

    public boolean isGameStarted() {
        return gameStarted;
    }

    // PlayerInfo 클래스는 플레이어 정보를 저장하는 클래스로 상황에 맞게 구현
}