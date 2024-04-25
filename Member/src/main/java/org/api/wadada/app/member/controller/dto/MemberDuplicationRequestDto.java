package org.api.wadada.app.member.controller.dto;

import jakarta.annotation.Nullable;
import lombok.Builder;
import lombok.Getter;

@Getter
public class MemberDuplicationRequestDto {
    @Nullable
    private String memberId;
    @Nullable
    private String nickname;

    @Builder
    public MemberDuplicationRequestDto(String memberId, String nickname) {
        this.memberId = memberId;
        this.nickname = nickname;
    }

    public boolean isAllNull(){
        return memberId == null && nickname == null;
    }
}
