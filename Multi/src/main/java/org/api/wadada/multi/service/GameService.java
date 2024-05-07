//package org.api.wadada.multi.service;
//
//
//import org.api.wadada.multi.dto.req.GameStartReq;
//import org.api.wadada.util.GameSession;
//import org.springframework.stereotype.Component;
//import org.springframework.stereotype.Service;
//
//import java.util.Map;
//import java.util.concurrent.ConcurrentHashMap;
//
//@Service
//public class GameService {
//    private final Map<String, GameSession> gameSessions = new ConcurrentHashMap<>();
//
//    // 방장이 게임 시작을 요청했을 때 호출되는 메소드
//    public void startGame(String sessionId) {
//        GameSession session = gameSessions.get(sessionId);
//        if (session != null) {
//            session.start();
//            // WebSocket을 사용하여 모든 유저에게 게임 시작 알림
//            notifyUsersGameStarted(sessionId);
//        }
//    }
//
//    // 유저가 게임 시작 정보를 제출했을 때 호출되는 메소드
//    public void submitGameStartInfo(String sessionId, GameStartReq info) {
//        GameSession session = gameSessions.get(sessionId);
//        if (session != null) {
//            session.addGameStartInfo(info);
//            // 모든 유저의 정보가 수집되었는지 확인
//            if (session.isReadyToStart()) {
//                // 게임 시작
//                notifyUsersGameStarted(sessionId);
//            }
//        }
//    }
//
//    private void notifyUsersGameStarted(String sessionId) {
//        // WebSocket을 사용하여 세션에 속한 모든 유저에게 게임 시작 메시지 전송
//
//        template.convertAndSend("/topic/game/start/" + sessionId, new GameStartedMessage());
//    }
//}
