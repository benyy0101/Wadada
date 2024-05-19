package org.api.wadada.app.member.repository;

import org.api.wadada.app.member.controller.dto.MemberDetailResponseDto;

import java.util.Optional;

public interface MemberCustomRepository {
    Optional<MemberDetailResponseDto> getMemberDetail(String memberId);
    boolean duplicationValid(String memberNickName);

}
