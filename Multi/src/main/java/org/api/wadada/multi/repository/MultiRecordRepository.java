package org.api.wadada.multi.repository;

import org.api.wadada.multi.dto.req.GameEndReq;
import org.api.wadada.multi.dto.res.GameEndRes;
import org.api.wadada.multi.entity.MultiRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MultiRecrodRepository  extends JpaRepository<MultiRecord, Integer> {


    public GameEndRes getMultiRecordByMemberSeq(GameEndReq gameEndReq){
        return new GameEndRes();
    }
}
