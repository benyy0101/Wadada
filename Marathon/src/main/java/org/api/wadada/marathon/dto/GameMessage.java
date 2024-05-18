package org.api.wadada.marathon.dto;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.api.wadada.marathon.dto.FlagPointRes;

@Getter
@RequiredArgsConstructor
public enum GameMessage {
    GAME_START_INFO_REQUEST("게임 시작 정보를 제출해주세요", "/Marathon/start"),
    GAME_START("게임이 시작되었습니다", "/Marathon/game/rank/{roomSeq}"),
    GAME_LIVE_INFO_REQUEST("멤버INFO요청", "/Marathon/game/data"),
    GAME_FLAG_INFO_REQUEST("깃발요청", "/Marathon/flag"),
    GAME_FLAG_ERROR("사용자 위치정보가 없습니다",""),

    MARATHON_CONNECTED("웹소켓연결","1"),
    MARATHON_INFO_SEND("정보전송","2");


    private final String message; // Java 변수명은 소문자로 시작하는 것이 관례입니다.
    private final String actionEndpoint; // 클라이언트가 호출해야 할 API 엔드포인트

    public String toJson() {
        return String.format("{\"header\": {\"status\": 200, \"statusText\": \"OK\"}, \"body\": {\"message\": \"%s\", \"action\": \"%s\"}}", message, actionEndpoint);
    }
    public String toErrorJson() {
        return String.format("{\"header\": {\"status\": 500, \"statusText\": \"RUNTIME_EXCEPTION\"}, \"body\": {\"message\": \"%s\", \"action\": \"%s\"}}", message, actionEndpoint);
    }
    public String toJson(int roomSeq) {
        String formattedEndpoint = actionEndpoint.replace("{roomSeq}", String.valueOf(roomSeq));
        return String.format("{\"header\": {\"status\": 200, \"statusText\": \"OK\"}, \"body\": {\"message\": \"%s\", \"action\": \"%s\", \"roomSeq\": %d}}", message, formattedEndpoint, roomSeq);
    }
    public String toJson(FlagPointRes res){
        return String.format("{\"header\": {\"status\": 200, \"statusText\": \"OK\"}, \"body\": {\"message\": \"%s\", \"latitude\": %f, \"longitude\": %f,}}", message, res.getLatitude(), res.getLongitude());
    }
}
