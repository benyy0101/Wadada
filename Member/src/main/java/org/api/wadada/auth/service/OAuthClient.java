package org.api.wadada.auth.service;


import org.api.wadada.auth.controller.dto.OAuthAccessTokenResponse;
import org.api.wadada.auth.controller.dto.OAuthMemberInfoResponse;

public interface OAuthClient {
    OAuthAccessTokenResponse getAccessToken(String code);
    OAuthMemberInfoResponse getMemberInfo(String accessToken);
}
