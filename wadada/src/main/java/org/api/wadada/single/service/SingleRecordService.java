package org.api.wadada.single.service;

import org.api.wadada.single.dto.req.SingleStartReq;
import org.api.wadada.single.dto.res.MainRes;
import org.locationtech.jts.io.ParseException;

public interface SingleRecordService {

    MainRes getSingleMain(int memberSeq);

    int saveStartSingle(SingleStartReq singleStartReq) throws ParseException;
}
