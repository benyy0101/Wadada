package org.api.wadada.marathon.dto;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum GameMessage {
    GAME_START_INFO_REQUEST("게임 시작 정보를 제출해주세요", "/Multi/start"),
    GAME_START("게임이 시작되었습니다", "/Multi/go");
    private final String message; // Java 변수명은 소문자로 시작하는 것이 관례입니다.
    private final String actionEndpoint; // 클라이언트가 호출해야 할 API 엔드포인트

    public String toJson() {
        return String.format("{\"message\": \"%s\", \"action\": \"%s\"}", message, actionEndpoint);
    }


}
