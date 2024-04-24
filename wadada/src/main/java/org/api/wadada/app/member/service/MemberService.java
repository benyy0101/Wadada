package org.api.wadada.app.member.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.app.member.controller.dto.MemberDetailResponseDto;
import org.api.wadada.app.member.controller.dto.MemberDuplicationRequestDto;
import org.api.wadada.app.member.controller.dto.MemberSigninRequestDto;
import org.api.wadada.app.member.controller.dto.MemberUpdateRequestDto;
import org.api.wadada.app.member.entity.Member;
import org.api.wadada.app.member.repository.MemberRepository;
import org.api.wadada.error.errorcode.CommonErrorCode;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class MemberService {

    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public Member create(MemberSigninRequestDto req) {
        Member member = Member.builder()
                .memberId(req.getMemberId())
                .password(passwordEncoder.encode(req.getPassword()))
                .nickname(req.getNickname())
                .roles(req.roles)
                .build();
        return memberRepository.save(member);
    }

    @Transactional
    public void update(MemberUpdateRequestDto req, String memberId) {
        Member member = memberRepository.findById(memberId).orElseThrow(() -> new RestApiException(CustomErrorCode.NO_MEMBER));

        socialUserPasswordValidation(req, member);

        encodePassword(req);

        member.updateMember(req);
    }

    private void socialUserPasswordValidation(MemberUpdateRequestDto req, Member member) {
        if (member.getRoles().contains("SOCIAL") && req.getPassword() != null){
            throw new RestApiException(CommonErrorCode.WRONG_REQUEST, "소셜로그인 유저는 비밀번호를 변경할 수 없습니다.");
        }
    }

    public boolean duplicationValid(MemberDuplicationRequestDto req) {
        if(req.getMemberId() != null){
            return memberRepository.countByMemberIdDeletedIncluded(req.getMemberId()) == 0;
        }
        if (req.getNickname() != null){
            return memberRepository.countByNicknameDeletedIncluded(req.getNickname()) == 0;
        }
        throw new RestApiException(CommonErrorCode.WRONG_REQUEST, "중복 검사할 값이 주어지지 않았습니다");
    }

    @Transactional
    public void delete(String memberId) {
        Member member = memberRepository.findById(memberId).orElseThrow(() -> new RestApiException(CustomErrorCode.NO_MEMBER));
        member.delete();
    }

    public MemberDetailResponseDto getMemberDetail(String memberId) {
        MemberDetailResponseDto res = memberRepository.getMemberDetail(memberId)
                .orElseThrow(() -> new RestApiException(CustomErrorCode.NO_MEMBER));
        return res;
    }

    private void encodePassword(MemberUpdateRequestDto req) {
        if (req.getPassword() != null)
            req.setPassword(passwordEncoder.encode(req.getPassword()));
    }
}
