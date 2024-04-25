package org.api.wadada.app.member.controller.dto;


import com.querydsl.core.annotations.QueryProjection;
import lombok.Getter;

@Getter
public class MemberSimpleResponseDto {
    private String memberId;
    private String nickname;
    private String profileImage;

    @QueryProjection
    public MemberSimpleResponseDto(String memberId, String nickname, String profileImage) {
        this.memberId = memberId;
        this.nickname = nickname;
        this.profileImage = profileImage;
    }
}
