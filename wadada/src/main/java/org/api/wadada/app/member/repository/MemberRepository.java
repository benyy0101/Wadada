package org.api.wadada.app.member.repository;

import io.lettuce.core.dynamic.annotation.Param;
import org.api.wadada.app.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, String>, MemberCustomRepository {

    Optional<Member> findByNickname(String nickname);

    @Query("SELECT m from Member m WHERE m.memberId = :memberId")
    Optional<Member> findByParentId(@Param("memberId") String memberId);
    boolean existsByNickname(String nickname);


    boolean existsByMemberId(String id);

    @Query("SELECT count(m) FROM Member m WHERE m.memberId = :memberId")
    int countByMemberIdDeletedIncluded(@Param("memberId") String memberId);

    @Query("SELECT count(m) FROM Member m WHERE m.nickname = :nickname")
    int countByNicknameDeletedIncluded(@Param("nickname") String nickname);

}
