package org.api.wadada.app.mypage.repository;

import org.api.wadada.app.mypage.Entity.MarathonRecord;
import org.api.wadada.app.mypage.Entity.MultiRecord;
import org.api.wadada.app.mypage.Entity.SingleRecord;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MultiRecordRepository extends JpaRepository<MultiRecord, Long> {

    // 멀티 기록에 대한 추가적인 메소드 정의 가능
}