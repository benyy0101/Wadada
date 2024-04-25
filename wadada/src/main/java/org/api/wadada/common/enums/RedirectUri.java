package org.api.wadada.common.enums;

public enum RedirectUri {
    KAKAO_PROD_OAUTH("https://j10a102.p.ssafy.io/login/kakao"),
    KAKAO_DEV_OAUTH("http://localhost:3000/login/kakao");

    private final String uri;

    RedirectUri(String uri) {
        this.uri = uri;
    }

    public String getUri() {
        return uri;
    }
}

