package org.api.wadada.error.errorcode;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum CustomErrorCode implements ErrorCode {

    NO_AUTHORIZATION(HttpStatus.FORBIDDEN, "해당 기능에 대한 권한이 없는 사용자입니다"),
    DUPLICATE_VALUE(HttpStatus.BAD_REQUEST, "중복 값이 허용되지 않습니다"),
    NO_MEMBER(HttpStatus.BAD_REQUEST, "ID에 해당하는 사용자가 존재하지 않습니다"),
    HEADER_ACCESS_TOKEN_NOT_EXISTS(HttpStatus.BAD_REQUEST, "access token이 존재하지 않습니다"),
    COOKIE_REFRESH_TOKEN_NOT_EXISTS(HttpStatus.BAD_REQUEST, "refresh token이 존재하지 않습니다"),
    INVALID_REFRESH_TOKEN(HttpStatus.BAD_REQUEST, "사용가능한 refresh token이 아닙니다"),
    NOT_VALID_USER(HttpStatus.UNAUTHORIZED, "사용자 권한이 유효하지 않습니다"),
    WRONG_ACCESS_WITHOUT_AUTHORIZATION(HttpStatus.FORBIDDEN, "비정상적인 접근입니다"),
    LOGIN_FAIL(HttpStatus.BAD_REQUEST, "아이디 혹은 비밀번호가 잘못되었습니다"),
    WRONG_PASSWORD(HttpStatus.BAD_REQUEST, "잘못된 비밀번호입니다."),
    ENCRYPTION_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "token 암호화가 실패하였습니다"),
    DECRYPTION_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "token 복호화가 실패하였습니다"),
    KAKAO_AUTHORIZATION_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "Kakao 정보를 얻어오는데 실패하였습니다"),

    DUPLICATE_RECORD(HttpStatus.INTERNAL_SERVER_ERROR,"이미 저장된 기록이 있습니다"),
    NO_ROOM(HttpStatus.INTERNAL_SERVER_ERROR,"방이 없습니다."),
    MARATHON_ROOM_STARTTIME_INVAILD(HttpStatus.BAD_REQUEST,"마라톤의 시작시간을 확인해주세요"),
    MARATHON_ROOM_ENDTIME_INVAILD(HttpStatus.BAD_REQUEST,"마라톤의 종료시간을 확인해주세요"),
    MARATHON_ROOM_NOT_CREATED(HttpStatus.BAD_REQUEST,"방이 생성되지 못했습니다"),
    MARATHON_ROOM_NOT_ATTEND(HttpStatus.BAD_REQUEST,"방에 참가하지 못했습니다"),
    MARATHON_ROOM_NOT_SAVE(HttpStatus.BAD_REQUEST,"기록을 저장할 수 없습니다");
    private final HttpStatus httpStatus;
    private final String message;
}

