package org.api.wadada.error.errorcode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum CommonErrorCode implements ErrorCode {

    INVALID_PARAMETER(HttpStatus.BAD_REQUEST, "입력값이 잘못되었습니다"),
    WRONG_REQUEST(HttpStatus.BAD_REQUEST, "요청이 잘못되었습니다"),
    RESOURCE_NOT_FOUND(HttpStatus.NOT_FOUND, "요청한 리소스가 존재하지 않습니다"),
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "서버 에러입니다");

    private final HttpStatus httpStatus;
    private final String message;
}

