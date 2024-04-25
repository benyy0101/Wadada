package org.api.wadada.auth.service;


import lombok.RequiredArgsConstructor;
import org.api.wadada.app.member.entity.Member;
import org.api.wadada.app.member.repository.MemberRepository;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final MemberRepository memberRepository;

    @Override
    public UserDetails loadUserByUsername(String memberId) throws UsernameNotFoundException {
        UserDetails user =  memberRepository.findByParentId(memberId)
                .map(this::createUserDetails)
                .orElseThrow(() -> new RestApiException(CustomErrorCode.NO_MEMBER));

        System.out.println("123123123123");

        return user;
    }

    // 멤버 정보를 UserDetail 객체로 변경하여 return
    private UserDetails createUserDetails(Member member) {
        return User.builder()
                .username(member.getMemberId())
                .password(member.getPassword())
                .roles(member.getRoles().toArray(new String[0]))
                .build();
    }
}
