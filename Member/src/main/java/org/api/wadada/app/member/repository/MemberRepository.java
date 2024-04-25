package org.api.wadada.app.member.repository;

import io.lettuce.core.dynamic.annotation.Param;
import org.api.wadada.app.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, String>, MemberCustomRepository {


    @Query("SELECT m from Member m WHERE m.memberId = :memberId and m.isDeleted = false")
    Optional<Member> findByParentId(@Param("memberId") String memberId);

    boolean existsByMemberIdAndIsDeleted(String memberId, boolean isDeleted);

}
