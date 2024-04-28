package org.api.wadada.app.mypage.Entity;

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

    private static final long serialVersionUID = 867703961L;

    public static final QMultiRecord multiRecord = new QMultiRecord("multiRecord");

    public final org.api.wadada.common.QBaseEntity _super = new org.api.wadada.common.QBaseEntity(this);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> createdAt = _super.createdAt;

    //inherited
    public final BooleanPath isDeleted = _super.isDeleted;

    public final NumberPath<Integer> memberSeq = createNumber("memberSeq", Integer.class);

    public final NumberPath<Integer> multiRecordDist = createNumber("multiRecordDist", Integer.class);

    public final SimplePath<java.awt.Point> multiRecordEnd = createSimple("multiRecordEnd", java.awt.Point.class);

    public final StringPath multiRecordHeartbeat = createString("multiRecordHeartbeat");

    public final StringPath multiRecordImage = createString("multiRecordImage");

    public final NumberPath<Byte> multiRecordMeanHeartbeat = createNumber("multiRecordMeanHeartbeat", Byte.class);

    public final NumberPath<Integer> multiRecordMeanPace = createNumber("multiRecordMeanPace", Integer.class);

    public final NumberPath<Integer> multiRecordMeanSpeed = createNumber("multiRecordMeanSpeed", Integer.class);

    public final StringPath multiRecordPace = createString("multiRecordPace");

    public final NumberPath<Byte> multiRecordPeople = createNumber("multiRecordPeople", Byte.class);

    public final NumberPath<Byte> multiRecordRank = createNumber("multiRecordRank", Byte.class);

    public final NumberPath<Integer> multiRecordSeq = createNumber("multiRecordSeq", Integer.class);

    public final StringPath multiRecordSpeed = createString("multiRecordSpeed");

    public final SimplePath<java.awt.Point> multiRecordStart = createSimple("multiRecordStart", java.awt.Point.class);

    public final NumberPath<Integer> multiRecordTime = createNumber("multiRecordTime", Integer.class);

    public final StringPath multiRecordWay = createString("multiRecordWay");

    public final NumberPath<Integer> roomSeq = createNumber("roomSeq", Integer.class);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> updatedAt = _super.updatedAt;

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

