package org.api.wadada.marathon.repository;

import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.api.wadada.marathon.dto.res.MainRes;
import org.api.wadada.marathon.dto.res.MarathonGameEndRes;
import org.api.wadada.marathon.dto.res.MarathonMemberListRes;
import org.api.wadada.marathon.dto.res.MarthonRankListRes;
import org.api.wadada.marathon.entity.MarathonRecord;
import org.api.wadada.marathon.entity.QMarathon;
import org.api.wadada.marathon.entity.QMarathonRecord;
import org.api.wadada.marathon.entity.QMember;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class MarathonRepositoryImpl implements MarathonCustomRepository{
    private final JPAQueryFactory jpaQueryFactory;

    public List<MainRes>  getMarathonList(){
        return jpaQueryFactory.select(Projections.constructor(MainRes.class,
                QMarathon.marathon.marathonSeq,
                QMarathon.marathon.marathonRound,
                QMarathon.marathon.marathonDist,
                QMarathon.marathon.marathonParticipate,
                QMarathon.marathon.marathonStart,
                QMarathon.marathon.marathonEnd,
                QMarathon.marathon.isDeleted)).from(QMarathon.marathon)
                .fetch();
    }

    @Override
    public List<MarathonMemberListRes> getMarathonMemberList(int marathonSeq) {
        // MarathonRecord를 통해 Member 정보를 가져오는 쿼리
        QMarathonRecord marathonRecord = QMarathonRecord.marathonRecord;
        QMember member = QMember.member;

        return jpaQueryFactory
                .select(Projections.constructor(MarathonMemberListRes.class,
                        member.memberNickName,
                        member.memberProfileImage))
                .from(marathonRecord)
                .join(marathonRecord.member, member) // MarathonRecord와 Member를 조인합니다.
                .where(marathonRecord.marathonSeq.eq(marathonSeq)) // MarathonSeq를 기준으로 필터링합니다.
                .fetch();
    }

    @Override
    public List<MarthonRankListRes> getMarathonRankList(int marathonSeq) {
        return jpaQueryFactory
                .select(Projections.constructor(MarthonRankListRes.class,
                        QMember.member.memberNickName,
                        QMember.member.memberProfileImage,
                        QMarathonRecord.marathonRecord.marathonRecordDist,
                        QMarathonRecord.marathonRecord.marathonRecordTime))
                .from(QMarathonRecord.marathonRecord)
                .join(QMarathonRecord.marathonRecord.member, QMember.member) // MarathonRecord와 Member를 연결
                .where(QMarathonRecord.marathonRecord.marathonSeq.eq(marathonSeq)) // marathonSeq에 해당하는 기록을 찾음
                .orderBy(QMarathonRecord.marathonRecord.marathonRecordDist.desc(), // Dist가 높은 순으로 정렬
                        QMarathonRecord.marathonRecord.marathonRecordTime.asc()) // 같은 Dist면 Time이 낮은 순으로 정렬
                .fetch();
    }

    @Override
    public Optional<MarathonRecord> findByMemberIdandMarathonSeq(int memberSeq, int marathonSeq) {
        QMarathonRecord qMarathonRecord = QMarathonRecord.marathonRecord;
        MarathonRecord found = jpaQueryFactory
                .selectFrom(qMarathonRecord)
                .where(qMarathonRecord.member.memberSeq.eq(memberSeq)
                        .and(qMarathonRecord.marathonSeq.eq(marathonSeq)))
                .fetchOne();
        return Optional.ofNullable(found);
    }



}
