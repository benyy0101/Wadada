package org.api.wadada.app.mypage.Entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QSingleRecord is a Querydsl query type for SingleRecord
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QSingleRecord extends EntityPathBase<SingleRecord> {

    private static final long serialVersionUID = -600129814L;

    public static final QSingleRecord singleRecord = new QSingleRecord("singleRecord");

    public final org.api.wadada.common.QBaseEntity _super = new org.api.wadada.common.QBaseEntity(this);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> createdAt = _super.createdAt;

    //inherited
    public final BooleanPath isDeleted = _super.isDeleted;

    public final NumberPath<Integer> memberSeq = createNumber("memberSeq", Integer.class);

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

    //inherited
    public final DateTimePath<java.time.LocalDateTime> updatedAt = _super.updatedAt;

    public QSingleRecord(String variable) {
        super(SingleRecord.class, forVariable(variable));
    }

    public QSingleRecord(Path<? extends SingleRecord> path) {
        super(path.getType(), path.getMetadata());
    }

    public QSingleRecord(PathMetadata metadata) {
        super(SingleRecord.class, metadata);
    }

}

