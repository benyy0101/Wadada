package org.api.wadada.multi.repository;

import org.api.wadada.multi.dto.req.GameEndReq;
import org.api.wadada.multi.dto.res.GameEndRes;

public interface MultiRecordCustomRepository {
    public GameEndRes getMultiRecordByMemberSeq(GameEndReq gameEndReq);
}
