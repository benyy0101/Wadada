package org.api.wadada.app.mypage.repository;

import com.querydsl.core.types.Expression;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.AllArgsConstructor;
import org.api.wadada.app.member.entity.Member;
import org.api.wadada.app.mypage.Entity.QMarathonRecord;
import org.api.wadada.app.mypage.Entity.QMultiRecord;
import org.api.wadada.app.mypage.Entity.QSingleRecord;
import org.api.wadada.app.mypage.Entity.SingleRecord;
import org.api.wadada.app.mypage.controller.dto.RecordDto;
import org.api.wadada.app.mypage.controller.dto.RecordListDto;
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
}