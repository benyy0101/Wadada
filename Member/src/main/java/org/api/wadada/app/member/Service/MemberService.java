package org.api.wadada.app.member.Service;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.api.wadada.app.member.controller.dto.MemberDetailResponseDto;
import org.api.wadada.app.member.controller.dto.MemberDuplicationVaildResponseDto;
import org.api.wadada.app.member.controller.dto.MemberUpdateRequestDto;
import org.api.wadada.app.member.entity.Member;
import org.api.wadada.app.member.repository.MemberRepository;
import org.api.wadada.auth.controller.dto.KakaoOAuthMemberInfoResponse;
import org.api.wadada.auth.controller.dto.LoginResponseDto;
import org.api.wadada.error.errorcode.CommonErrorCode;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional(readOnly = true)
@AllArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;

    @Transactional
    public void deleteMember(String memberId) {
        System.out.println(memberId);
        Member member = memberRepository.findByParentId(memberId).orElseThrow(() -> new RestApiException(CustomErrorCode.NO_MEMBER));
        member.delete();
    }
    @Transactional
    public void update(MemberUpdateRequestDto req, String memberId) {
        Member member = memberRepository.findByParentId(memberId).orElseThrow(() -> new RestApiException(CustomErrorCode.NO_MEMBER));
        member.updateMember(req);
    }

    public MemberDetailResponseDto getMemberDetail(String memberId) {
        MemberDetailResponseDto res = memberRepository.getMemberDetail(memberId)
                .orElseThrow(() -> new RestApiException(CustomErrorCode.NO_MEMBER));
        return res;
    }

    public MemberDuplicationVaildResponseDto duplicationValid(String memberNickName) {
        if(memberNickName != null){
            if(memberRepository.duplicationValid(memberNickName)){
                return new MemberDuplicationVaildResponseDto(true);
            }
        }
        throw new RestApiException(CommonErrorCode.WRONG_REQUEST, "중복 검사할 값이 주어지지 않았습니다");
    }
}
