package org.api.wadada.app.mypage.repository;

import com.querydsl.core.types.Expression;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.AllArgsConstructor;
import org.api.wadada.app.member.entity.Member;
import org.api.wadada.app.member.entity.QMember;
import org.api.wadada.app.mypage.Entity.QMarathonRecord;
import org.api.wadada.app.mypage.Entity.QMultiRecord;
import org.api.wadada.app.mypage.Entity.QSingleRecord;
import org.api.wadada.app.mypage.Entity.SingleRecord;
import org.api.wadada.app.mypage.controller.dto.*;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
@AllArgsConstructor
public class MyPageRepositoryImpl {
    private final JPAQueryFactory jpaQueryFactory;


    public RecordListDto getRecord(Integer memberSeq, LocalDateTime startDateTime, LocalDateTime endDateTime) {
        List<RecordDto> list = new ArrayList<>();

        list.addAll(jpaQueryFactory
            .select(Projections.constructor(RecordDto.class,
                    QSingleRecord.singleRecord.singleRecordSeq,
                    Expressions.constant("1"), // 'type' 필드에 대한 임의의 값 "1"을 설정
                    QSingleRecord.singleRecord.singleRecordDist,
                    QSingleRecord.singleRecord.createdAt))
            .from(QSingleRecord.singleRecord)
            .where(QSingleRecord.singleRecord.memberSeq.eq(memberSeq)
                    .and(QSingleRecord.singleRecord.createdAt.between(startDateTime, endDateTime)))
            .fetch());
        list.addAll(jpaQueryFactory
                .select(Projections.constructor(RecordDto.class,
                        QMultiRecord.multiRecord.multiRecordSeq,
                        Expressions.constant("2"), // 'type' 필드에 대한 임의의 값 "1"을 설정
                        QMultiRecord.multiRecord.multiRecordDist,
                        QMultiRecord.multiRecord.createdAt))
                .from(QMultiRecord.multiRecord)
                .where(QMultiRecord.multiRecord.memberSeq.eq(memberSeq)
                        .and(QMultiRecord.multiRecord.createdAt.between(startDateTime, endDateTime)))
                .fetch());
        list.addAll(jpaQueryFactory
                .select(Projections.constructor(RecordDto.class,
                        QMarathonRecord.marathonRecord.marathonRecordSeq,
                        Expressions.constant("3"), // 'type' 필드에 대한 임의의 값 "1"을 설정
                        QMarathonRecord.marathonRecord.marathonRecordDist,
                        QMarathonRecord.marathonRecord.createdAt))
                .from(QMarathonRecord.marathonRecord)
                .where(QMarathonRecord.marathonRecord.memberSeq.eq(memberSeq)
                        .and(QMarathonRecord.marathonRecord.createdAt.between(startDateTime, endDateTime)))
                .fetch());
        RecordListDto recordListDto = new RecordListDto(list);
        return recordListDto;
    }

    public SingleRecordDto getSingleRecord(int memberSeq, int singleRecordSeq) {
        QSingleRecord singleRecord = QSingleRecord.singleRecord;
        return jpaQueryFactory
                .select(Projections.constructor(SingleRecordDto.class,
                        Expressions.constant("1"), // 'recordType' 필드에 대한 임의의 값 "1"을 설정
                        singleRecord.singleRecordImage,
                        singleRecord.singleRecordDist,
                        singleRecord.singleRecordTime,
                        Expressions.stringTemplate("ST_AsText({0})", singleRecord.singleRecordStart), // 'recordStartLocation' 변환
                        Expressions.stringTemplate("ST_AsText({0})", singleRecord.singleRecordEnd), // 'recordEndLocation' 변환
                        singleRecord.singleRecordSpeed,
                        singleRecord.singleRecordHeartbeat,
                        singleRecord.singleRecordPace,
                        singleRecord.createdAt,
                        singleRecord.singleRecordMeanPace,
                        singleRecord.singleRecordMeanSpeed,
                        singleRecord.singleRecordMeanHeartbeat))
                .from(singleRecord)
                .where(singleRecord.memberSeq.eq(memberSeq)
                        .and(singleRecord.singleRecordSeq.eq(singleRecordSeq)))
                .fetchOne();
    }

    public MultiRecordDto getMultiRecord(int memberSeq, int multiRecordSeq) {
        QMultiRecord multiRecord = QMultiRecord.multiRecord;

        Integer RoomNumber = jpaQueryFactory
                .select(multiRecord.roomSeq)
                .from(multiRecord)
                .where(multiRecord.memberSeq.eq(memberSeq)
                        .and(multiRecord.multiRecordSeq.eq(multiRecordSeq)))
                .fetchOne();
        // 순위가 없다면 null 반환
        if (RoomNumber == null) {
            return null;
        }

        // 해당 순위를 기준으로 위아래 포함 5명의 정보 조회
        List<RecordDetailDto> rankings;

        rankings= jpaQueryFactory
                .select(Projections.constructor(RecordDetailDto.class,
                        QMember.member.memberNickName,
                        QMember.member.memberProfileImage,
                        multiRecord.multiRecordRank,
                        multiRecord.multiRecordTime))
                .from(multiRecord)
                .join(QMember.member).on(QMember.member.memberSeq.eq(multiRecord.memberSeq)) // memberSeq를 기준으로 조인
                .where(multiRecord.roomSeq.eq(RoomNumber))
                .orderBy(multiRecord.multiRecordRank.asc())
                .fetch();

        return jpaQueryFactory
                .select(Projections.constructor(MultiRecordDto.class,
                        Expressions.constant("2"), // 'recordType' 필드에 대한 임의의 값 "1"을 설정
                        multiRecord.multiRecordRank,
                        multiRecord.multiRecordImage,
                        multiRecord.multiRecordDist,
                        multiRecord.multiRecordTime,
                        Expressions.stringTemplate("ST_AsText({0})", multiRecord.multiRecordStart), // 'recordStartLocation' 변환
                        Expressions.stringTemplate("ST_AsText({0})", multiRecord.multiRecordEnd), // 'recordEndLocation' 변환
                        multiRecord.multiRecordSpeed,
                        multiRecord.multiRecordHeartbeat,
                        multiRecord.multiRecordPace,
                        multiRecord.createdAt,
                        multiRecord.multiRecordMeanPace,
                        multiRecord.multiRecordMeanSpeed,
                        multiRecord.multiRecordMeanHeartbeat,
                        Expressions.constant(rankings)))
                .from(multiRecord)
                .where(multiRecord.memberSeq.eq(memberSeq)
                        .and(multiRecord.multiRecordSeq.eq(multiRecordSeq)))
                .fetchOne();
    }
    public MarathonRecordDto getMarathonRecord(int memberSeq, int MarathonRecordSeq) {
        QMarathonRecord marathonRecord = QMarathonRecord.marathonRecord;

        Byte myRank = jpaQueryFactory
                .select(marathonRecord.marathonRecordRank)
                .from(marathonRecord)
                .where(marathonRecord.memberSeq.eq(memberSeq)
                        .and(marathonRecord.marathonRecordSeq.eq(MarathonRecordSeq)))
                .fetchOne();
        System.out.println(myRank);
        // 순위가 없다면 null 반환
        if (myRank == null) {
            return null;
        }

        // 해당 순위를 기준으로 위아래 포함 5명의 정보 조회
        List<RecordDetailDto> rankings;

        rankings= jpaQueryFactory
                .select(Projections.constructor(RecordDetailDto.class,
                        QMember.member.memberNickName,
                        QMember.member.memberProfileImage,
                        marathonRecord.marathonRecordRank,
                        marathonRecord.marathonRecordTime))
                .from(marathonRecord)
                .join(QMember.member).on(QMember.member.memberSeq.eq(marathonRecord.memberSeq)) // memberSeq를 기준으로 조인
                .where(marathonRecord.marathonRecordRank.between(myRank - 2, myRank + 2))
                .orderBy(marathonRecord.marathonRecordRank.asc())
                .fetch();

        return jpaQueryFactory
                .select(Projections.constructor(MarathonRecordDto.class,
                        Expressions.constant("3"), // 'recordType' 필드에 대한 임의의 값 "1"을 설정
                        marathonRecord.marathonRecordRank,
                        marathonRecord.marathonRecodeImage,
                        marathonRecord.marathonRecordDist,
                        marathonRecord.marathonRecordTime,
                        Expressions.stringTemplate("ST_AsText({0})", marathonRecord.marathonRecordStart), // 'recordStartLocation' 변환
                        Expressions.stringTemplate("ST_AsText({0})", marathonRecord.marathonRecordEnd), // 'recordEndLocation' 변환
                        marathonRecord.marathonRecordSpeed,
                        marathonRecord.marathonRecordHeartbeat,
                        marathonRecord.marathonRecodePace,
                        marathonRecord.createdAt,
                        marathonRecord.marathonRecordMeanPace,
                        marathonRecord.marathonRecordMeanSpeed,
                        marathonRecord.marathonRecordMeanHeartbeat,
                        Expressions.constant(rankings)))
                .from(marathonRecord)
                .where(marathonRecord.memberSeq.eq(memberSeq)
                        .and(marathonRecord.marathonRecordSeq.eq(MarathonRecordSeq)))
                .fetchOne();
    }

}