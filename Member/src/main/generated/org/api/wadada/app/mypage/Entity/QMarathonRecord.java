package org.api.wadada.app.mypage.Entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QMarathonRecord is a Querydsl query type for MarathonRecord
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QMarathonRecord extends EntityPathBase<MarathonRecord> {

    private static final long serialVersionUID = 2093169784L;

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

    public final SimplePath<java.awt.Point> marathonRecordEnd = createSimple("marathonRecordEnd", java.awt.Point.class);

    public final StringPath marathonRecordHeartbeat = createString("marathonRecordHeartbeat");

    public final BooleanPath marathonRecordIsWin = createBoolean("marathonRecordIsWin");

    public final NumberPath<Integer> marathonRecordMeanHeartbeat = createNumber("marathonRecordMeanHeartbeat", Integer.class);

    public final NumberPath<Integer> marathonRecordMeanPace = createNumber("marathonRecordMeanPace", Integer.class);

    public final NumberPath<Integer> marathonRecordMeanSpeed = createNumber("marathonRecordMeanSpeed", Integer.class);

    public final NumberPath<Integer> marathonRecordSeq = createNumber("marathonRecordSeq", Integer.class);

    public final StringPath marathonRecordSpeed = createString("marathonRecordSpeed");

    public final SimplePath<java.awt.Point> marathonRecordStart = createSimple("marathonRecordStart", java.awt.Point.class);

    public final NumberPath<Integer> marathonRecordTime = createNumber("marathonRecordTime", Integer.class);

    public final NumberPath<Integer> marathonSeq = createNumber("marathonSeq", Integer.class);

    public final NumberPath<Integer> memberSeq = createNumber("memberSeq", Integer.class);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> updatedAt = _super.updatedAt;

    public QMarathonRecord(String variable) {
        super(MarathonRecord.class, forVariable(variable));
    }

    public QMarathonRecord(Path<? extends MarathonRecord> path) {
        super(path.getType(), path.getMetadata());
    }

    public QMarathonRecord(PathMetadata metadata) {
        super(MarathonRecord.class, metadata);
    }

}

