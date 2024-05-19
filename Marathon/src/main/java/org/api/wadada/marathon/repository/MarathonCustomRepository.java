package org.api.wadada.marathon.repository;

import org.api.wadada.marathon.dto.res.MainRes;
import org.api.wadada.marathon.dto.res.MarathonGameEndRes;
import org.api.wadada.marathon.dto.res.MarathonMemberListRes;
import org.api.wadada.marathon.dto.res.MarthonRankListRes;
import org.api.wadada.marathon.entity.MarathonRecord;

import java.util.List;
import java.util.Optional;

public interface MarathonCustomRepository {
    List<MainRes> getMarathonList();

    List<MarathonMemberListRes> getMarathonMemberList(int marathonSeq);

    List<MarthonRankListRes> getMarathonRankList(int marathonSeq);

    Optional<MarathonRecord> findByMemberIdandMarathonSeq(int memberSeq, int marathonSeq);

}
