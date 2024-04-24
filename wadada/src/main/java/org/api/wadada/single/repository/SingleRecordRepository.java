package org.api.wadada.single.repository;

import org.api.wadada.single.entity.SingleRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface SingleRecordRepository extends JpaRepository<SingleRecord, Integer> {


    List<SingleRecord> getSingleRecordByMemberSeq(int MemberSeq);
}
