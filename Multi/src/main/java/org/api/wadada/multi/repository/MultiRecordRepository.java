package org.api.wadada.multi.repository;

import io.lettuce.core.dynamic.annotation.Param;
import org.api.wadada.multi.dto.req.GameEndReq;
import org.api.wadada.multi.dto.res.GameEndRes;
import org.api.wadada.multi.entity.MultiRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MultiRecordRepository extends JpaRepository<MultiRecord, Integer> , MultiRecordCustomRepository{
    @Query("SELECT m from MultiRecord m WHERE m.memberSeq = :memberSeq and m.isDeleted = false")
    Optional<MultiRecord> findByMemberId(@Param("memberSeq") Integer memberSeq);

    @Query("SELECT m from MultiRecord m WHERE m.memberSeq = :memberSeq and m.isDeleted = false and m.roomSeq = :roomSeq")
    Optional<MultiRecord> findByMemberIdandRoomSeq(@Param("memberSeq") Integer memberSeq,@Param("roomSeq") Integer roomSeq);

}
