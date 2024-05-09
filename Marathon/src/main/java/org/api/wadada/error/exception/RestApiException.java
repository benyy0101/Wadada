package org.api.wadada.error.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.api.wadada.error.errorcode.ErrorCode;

@Getter
@RequiredArgsConstructor
public class RestApiException extends RuntimeException{
    private final ErrorCode errorCode;
    private final String message;

    public RestApiException(ErrorCode errorCode){
        this.errorCode = errorCode;
        this.message = errorCode.getMessage();
    }

}

