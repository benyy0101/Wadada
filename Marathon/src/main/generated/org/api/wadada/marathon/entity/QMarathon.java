package org.api.wadada.marathon.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QMarathon is a Querydsl query type for Marathon
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QMarathon extends EntityPathBase<Marathon> {

    private static final long serialVersionUID = -1329409451L;

    public static final QMarathon marathon = new QMarathon("marathon");

    public final org.api.wadada.common.QBaseEntity _super = new org.api.wadada.common.QBaseEntity(this);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> createdAt = _super.createdAt;

    //inherited
    public final BooleanPath isDeleted = _super.isDeleted;

    public final NumberPath<Integer> marathonDist = createNumber("marathonDist", Integer.class);

    public final DateTimePath<java.time.LocalDateTime> marathonEnd = createDateTime("marathonEnd", java.time.LocalDateTime.class);

    public final NumberPath<Short> marathonGoal = createNumber("marathonGoal", Short.class);

    public final NumberPath<Integer> marathonParticipate = createNumber("marathonParticipate", Integer.class);

    public final NumberPath<Short> marathonRound = createNumber("marathonRound", Short.class);

    public final NumberPath<Integer> marathonSeq = createNumber("marathonSeq", Integer.class);

    public final DateTimePath<java.time.LocalDateTime> marathonStart = createDateTime("marathonStart", java.time.LocalDateTime.class);

    public final StringPath marathonText = createString("marathonText");

    public final StringPath marathonTitle = createString("marathonTitle");

    public final NumberPath<Byte> marathonType = createNumber("marathonType", Byte.class);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> updatedAt = _super.updatedAt;

    public QMarathon(String variable) {
        super(Marathon.class, forVariable(variable));
    }

    public QMarathon(Path<? extends Marathon> path) {
        super(path.getType(), path.getMetadata());
    }

    public QMarathon(PathMetadata metadata) {
        super(Marathon.class, metadata);
    }

}

