package org.api.wadada.multi.repository;

import org.api.wadada.multi.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Integer> {

    @Query("SELECT m FROM Member m WHERE m.memberId = :memberId")
    Optional<Member> getMemberByMemberId(String memberId);
}
