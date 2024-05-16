package org.api.wadada.marathon.service;

import org.api.wadada.marathon.dto.req.MarathonCreateReq;
import org.api.wadada.marathon.dto.req.MarathonGameEndReq;
import org.api.wadada.marathon.dto.req.MarathonGameStartReq;
import org.api.wadada.marathon.dto.req.RequestDataReq;
import org.api.wadada.marathon.dto.res.*;

import java.security.Principal;
import java.util.List;

public interface MarathonService {

    List<MainRes> getMarathonMain();
    List<MarathonMemberListRes> getMarathonMemberList(int marathonSeq);
    List<MarthonRankListRes> getMarathonRankList(int marathonSeq);
    Integer startMarathon(Principal principal, MarathonCreateReq marathonCreateReq);
    Integer isMarathonReady(Principal principal,int marathonSeq) throws Exception;

    MarathonGameStartRes saveStartMarathon(Principal principal, MarathonGameStartReq marathonGameStartReq);
    MarathonGameEndRes saveEndMarathon(Principal principal, MarathonGameEndReq marathonGameEndReq);

    boolean isEndGame(int RoomSeq);


    void savePlayerData(Principal principal, RequestDataReq requestDataReq);

    void getPlayerRank(int roomSeq);
    void stopPlayerRankUpdates(int roomSeq);

}
