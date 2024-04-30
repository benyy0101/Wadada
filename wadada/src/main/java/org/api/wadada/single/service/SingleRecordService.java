package org.api.wadada.single.service;

import org.api.wadada.single.dto.req.SingleEndReq;
import org.api.wadada.single.dto.req.SingleStartReq;
import org.api.wadada.single.dto.res.MainRes;
import org.api.wadada.single.entity.Member;
import org.locationtech.jts.io.ParseException;

import java.security.Principal;

public interface SingleRecordService {

    MainRes getSingleMain(Principal principal);

    int saveStartSingle(Principal principal, SingleStartReq singleStartReq) throws ParseException;

    int saveEndSingle(Principal principal,SingleEndReq singleEndReq) throws ParseException;
}
