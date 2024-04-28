package org.api.wadada.app.mypage.repository;

import org.api.wadada.app.member.controller.dto.MemberDetailResponseDto;
import org.api.wadada.app.mypage.Entity.MarathonRecord;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface MarathonRecordRepository extends JpaRepository<MarathonRecord, Long> {

    // 마라톤 기록에 대한 추가적인 메소드 정의 가능
}
