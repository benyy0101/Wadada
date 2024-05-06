package org.api.wadada.multi.service;

import org.api.wadada.multi.dto.req.GameEndReq;
import org.api.wadada.multi.dto.req.GameStartReq;
import org.api.wadada.multi.dto.res.GameEndRes;
import org.api.wadada.multi.dto.res.GameResultRes;
import org.api.wadada.multi.dto.res.GameStartRes;
import org.locationtech.jts.io.ParseException;

import java.security.Principal;

public interface MultiRecordService {

    GameStartRes saveStartMulti(Principal principal, GameStartReq gameStartReq) throws ParseException;

    GameEndRes saveEndMulti(Principal principal, GameEndReq gameEndReq) throws ParseException;

    GameResultRes getResultMulti(Principal principal, Integer roomSeq) throws ParseException;
}
