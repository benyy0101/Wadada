package org.api.wadada.marathon.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QMarathonRecord is a Querydsl query type for MarathonRecord
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QMarathonRecord extends EntityPathBase<MarathonRecord> {

    private static final long serialVersionUID = -1778755834L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QMarathonRecord marathonRecord = new QMarathonRecord("marathonRecord");

    public final org.api.wadada.common.QBaseEntity _super = new org.api.wadada.common.QBaseEntity(this);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> createdAt = _super.createdAt;

    //inherited
    public final BooleanPath isDeleted = _super.isDeleted;

    public final StringPath marathonRecodeImage = createString("marathonRecodeImage");

    public final StringPath marathonRecodePace = createString("marathonRecodePace");

    public final StringPath marathonRecodeWay = createString("marathonRecodeWay");

    public final NumberPath<Integer> marathonRecordDist = createNumber("marathonRecordDist", Integer.class);

    public final StringPath marathonRecordEnd = createString("marathonRecordEnd");

    public final StringPath marathonRecordHeartbeat = createString("marathonRecordHeartbeat");

    public final BooleanPath marathonRecordIsWin = createBoolean("marathonRecordIsWin");

    public final NumberPath<Byte> marathonRecordMeanHeartbeat = createNumber("marathonRecordMeanHeartbeat", Byte.class);

    public final NumberPath<Integer> marathonRecordMeanPace = createNumber("marathonRecordMeanPace", Integer.class);

    public final NumberPath<Integer> marathonRecordMeanSpeed = createNumber("marathonRecordMeanSpeed", Integer.class);

    public final NumberPath<Byte> marathonRecordRank = createNumber("marathonRecordRank", Byte.class);

    public final NumberPath<Integer> marathonRecordSeq = createNumber("marathonRecordSeq", Integer.class);

    public final StringPath marathonRecordSpeed = createString("marathonRecordSpeed");

    public final StringPath marathonRecordStart = createString("marathonRecordStart");

    public final NumberPath<Integer> marathonRecordTime = createNumber("marathonRecordTime", Integer.class);

    public final NumberPath<Integer> marathonSeq = createNumber("marathonSeq", Integer.class);

    public final QMember member;

    //inherited
    public final DateTimePath<java.time.LocalDateTime> updatedAt = _super.updatedAt;

    public QMarathonRecord(String variable) {
        this(MarathonRecord.class, forVariable(variable), INITS);
    }

    public QMarathonRecord(Path<? extends MarathonRecord> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QMarathonRecord(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QMarathonRecord(PathMetadata metadata, PathInits inits) {
        this(MarathonRecord.class, metadata, inits);
    }

    public QMarathonRecord(Class<? extends MarathonRecord> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.member = inits.isInitialized("member") ? new QMember(forProperty("member")) : null;
    }

}

