package org.api.wadada.multi.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QMultiRecord is a Querydsl query type for MultiRecord
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QMultiRecord extends EntityPathBase<MultiRecord> {

    private static final long serialVersionUID = -93994656L;

    public static final QMultiRecord multiRecord = new QMultiRecord("multiRecord");

    public final DateTimePath<java.time.LocalDateTime> createdAt = createDateTime("createdAt", java.time.LocalDateTime.class);

    public final BooleanPath isDeleted = createBoolean("isDeleted");

    public final NumberPath<Integer> memberSeq = createNumber("memberSeq", Integer.class);

    public final NumberPath<Integer> multiRecordDist = createNumber("multiRecordDist", Integer.class);

    public final ComparablePath<org.locationtech.jts.geom.Point> multiRecordEnd = createComparable("multiRecordEnd", org.locationtech.jts.geom.Point.class);

    public final StringPath multiRecordHeartbeat = createString("multiRecordHeartbeat");

    public final StringPath multiRecordImage = createString("multiRecordImage");

    public final NumberPath<Integer> multiRecordMeanHeartbeat = createNumber("multiRecordMeanHeartbeat", Integer.class);

    public final NumberPath<Integer> multiRecordMeanPace = createNumber("multiRecordMeanPace", Integer.class);

    public final NumberPath<Integer> multiRecordMeanSpeed = createNumber("multiRecordMeanSpeed", Integer.class);

    public final StringPath multiRecordPace = createString("multiRecordPace");

    public final NumberPath<Integer> multiRecordPeople = createNumber("multiRecordPeople", Integer.class);

    public final NumberPath<Integer> multiRecordRank = createNumber("multiRecordRank", Integer.class);

    public final NumberPath<Integer> multiRecordSeq = createNumber("multiRecordSeq", Integer.class);

    public final StringPath multiRecordSpeed = createString("multiRecordSpeed");

    public final ComparablePath<org.locationtech.jts.geom.Point> multiRecordStart = createComparable("multiRecordStart", org.locationtech.jts.geom.Point.class);

    public final NumberPath<Integer> multiRecordTime = createNumber("multiRecordTime", Integer.class);

    public final StringPath multiRecordWay = createString("multiRecordWay");

    public final StringPath recordMode = createString("recordMode");

    public final NumberPath<Integer> roomSeq = createNumber("roomSeq", Integer.class);

    public final DateTimePath<java.time.LocalDateTime> updatedAt = createDateTime("updatedAt", java.time.LocalDateTime.class);

    public QMultiRecord(String variable) {
        super(MultiRecord.class, forVariable(variable));
    }

    public QMultiRecord(Path<? extends MultiRecord> path) {
        super(path.getType(), path.getMetadata());
    }

    public QMultiRecord(PathMetadata metadata) {
        super(MultiRecord.class, metadata);
    }

}

