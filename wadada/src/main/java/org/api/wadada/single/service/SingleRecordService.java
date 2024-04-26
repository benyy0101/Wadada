package org.api.wadada.single.service;

import org.api.wadada.single.dto.req.SingleEndReq;
import org.api.wadada.single.dto.req.SingleStartReq;
import org.api.wadada.single.dto.res.MainRes;
import org.api.wadada.single.entity.Member;
import org.locationtech.jts.io.ParseException;

public interface SingleRecordService {

    MainRes getSingleMain(int memberSeq);

    int saveStartSingle(Member member, SingleStartReq singleStartReq) throws ParseException;

    int saveEndSingle(Member member,SingleEndReq singleEndReq) throws ParseException;
}
