package org.api.wadada.app.member.repository;

import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.AllArgsConstructor;
import org.api.wadada.app.member.controller.dto.MemberDetailResponseDto;
import org.api.wadada.app.member.entity.Member;
import org.api.wadada.app.member.entity.QMember;
import org.api.wadada.error.errorcode.CommonErrorCode;
import org.api.wadada.error.exception.RestApiException;

import java.util.Optional;

import static org.api.wadada.app.member.entity.QMember.member;

@AllArgsConstructor
public class MemberCustomRepositoryImpl implements MemberCustomRepository{
    private final JPAQueryFactory jpaQueryFactory;

    @Override
    public Optional<MemberDetailResponseDto> getMemberDetail(String memberId) {
        MemberDetailResponseDto res = jpaQueryFactory
                .select(Projections.constructor(
                        MemberDetailResponseDto.class,
                        member.memberNickName,
                        member.memberBirthday,
                        member.memberGender,
                        member.memberMainEmail,
                        member.memberProfileImage,
                        member.memberExp,
                        member.memberLevel

                ))
                .from(member)
                .where(member.memberId.eq(memberId)
                        .and(member.isDeleted.eq(false)))
                .fetchOne();
        if (res == null) return Optional.empty();

        return Optional.of(res);
    }

    @Override
    public boolean duplicationValid(String memberNickName) {
        Member member = jpaQueryFactory
                .selectFrom(QMember.member)
                .where(QMember.member.memberNickName.eq(memberNickName)
                        .and(QMember.member.isDeleted.eq(false)))
                .fetchOne();
        return member != null;
    }

}
