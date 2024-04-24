package org.api.wadada.single.repository;

import org.api.wadada.single.dto.res.MainRes;
import org.api.wadada.single.entity.SingleRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface SingleRecordRepository extends JpaRepository<SingleRecord, Integer> {

    // Point 직렬화 이슈 때문에 필요한 것만 골라서 가져옴...
    @Query("SELECT new org.api.wadada.single.dto.res.MainRes(s.singleRecordTime,s.singleRecordDist,s.singleRecordMeanSpeed" +
            ",s.singleRecordMeanHeartbeat,s.singleRecordMeanPace) " +
            " FROM SingleRecord s WHERE s.member.memberSeq = :memberSeq ORDER BY s.createdAt DESC LIMIT 1")
    Optional<MainRes> getSingleRecordByMemberSeq(int memberSeq);
}
