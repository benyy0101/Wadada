package org.api.wadada.single.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QSingleRecord is a Querydsl query type for SingleRecord
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QSingleRecord extends EntityPathBase<SingleRecord> {

    private static final long serialVersionUID = -903216470L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QSingleRecord singleRecord = new QSingleRecord("singleRecord");

    public final DateTimePath<java.time.LocalDateTime> createdAt = createDateTime("createdAt", java.time.LocalDateTime.class);

    public final NumberPath<Integer> isDeleted = createNumber("isDeleted", Integer.class);

    public final QMember member;

    public final NumberPath<Integer> singleRecordDist = createNumber("singleRecordDist", Integer.class);

    public final ComparablePath<org.locationtech.jts.geom.Point> singleRecordEnd = createComparable("singleRecordEnd", org.locationtech.jts.geom.Point.class);

    public final StringPath singleRecordHeartbeat = createString("singleRecordHeartbeat");

    public final StringPath singleRecordImage = createString("singleRecordImage");

    public final NumberPath<Integer> singleRecordMeanHeartbeat = createNumber("singleRecordMeanHeartbeat", Integer.class);

    public final NumberPath<Integer> singleRecordMeanPace = createNumber("singleRecordMeanPace", Integer.class);

    public final NumberPath<Integer> singleRecordMeanSpeed = createNumber("singleRecordMeanSpeed", Integer.class);

    public final NumberPath<Integer> singleRecordMode = createNumber("singleRecordMode", Integer.class);

    public final StringPath singleRecordPace = createString("singleRecordPace");

    public final NumberPath<Integer> singleRecordSeq = createNumber("singleRecordSeq", Integer.class);

    public final StringPath singleRecordSpeed = createString("singleRecordSpeed");

    public final ComparablePath<org.locationtech.jts.geom.Point> singleRecordStart = createComparable("singleRecordStart", org.locationtech.jts.geom.Point.class);

    public final NumberPath<Integer> singleRecordTime = createNumber("singleRecordTime", Integer.class);

    public final StringPath singleRecordWay = createString("singleRecordWay");

    public final DateTimePath<java.time.LocalDateTime> updatedAt = createDateTime("updatedAt", java.time.LocalDateTime.class);

    public QSingleRecord(String variable) {
        this(SingleRecord.class, forVariable(variable), INITS);
    }

    public QSingleRecord(Path<? extends SingleRecord> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QSingleRecord(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QSingleRecord(PathMetadata metadata, PathInits inits) {
        this(SingleRecord.class, metadata, inits);
    }

    public QSingleRecord(Class<? extends SingleRecord> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.member = inits.isInitialized("member") ? new QMember(forProperty("member")) : null;
    }

}

