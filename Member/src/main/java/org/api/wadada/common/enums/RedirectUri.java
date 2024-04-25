package org.api.wadada.common.enums;

public enum RedirectUri {
    KAKAO_PROD_OAUTH("https://j10a102.p.ssafy.io/login/kakao"),
    KAKAO_DEV_OAUTH("http://localhost:8080/Wadada/auth/login");

    private final String uri;

    RedirectUri(String uri) {
        this.uri = uri;
    }

    public String getUri() {
        return uri;
    }
}

