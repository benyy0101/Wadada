package org.api.wadada.util;

import org.api.wadada.app.member.entity.Member;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

public class MemberUtil {
    public static String getMemberId(){
        Member member = (Member) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return member.getMemberId();
    }
    public static Integer getMemberSeq(){
        Member member = (Member) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return member.getMemberSeq();
    }
}
