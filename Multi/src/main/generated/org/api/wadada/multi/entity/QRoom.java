package org.api.wadada.multi.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QRoom is a Querydsl query type for Room
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QRoom extends EntityPathBase<Room> {

    private static final long serialVersionUID = 1660131109L;

    public static final QRoom room = new QRoom("room");

    public final org.api.wadada.common.QBaseEntity _super = new org.api.wadada.common.QBaseEntity(this);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> createdAt = _super.createdAt;

    //inherited
    public final BooleanPath isDeleted = _super.isDeleted;

    public final NumberPath<Integer> roomDist = createNumber("roomDist", Integer.class);

    public final NumberPath<Integer> roomMaker = createNumber("roomMaker", Integer.class);

    public final NumberPath<Integer> roomMode = createNumber("roomMode", Integer.class);

    public final NumberPath<Integer> roomPeople = createNumber("roomPeople", Integer.class);

    public final NumberPath<Integer> roomSecret = createNumber("roomSecret", Integer.class);

    public final NumberPath<Integer> roomSeq = createNumber("roomSeq", Integer.class);

    public final StringPath roomTag = createString("roomTag");

    public final ComparablePath<org.locationtech.jts.geom.Point> roomTargetPoint = createComparable("roomTargetPoint", org.locationtech.jts.geom.Point.class);

    public final NumberPath<Integer> roomTime = createNumber("roomTime", Integer.class);

    public final StringPath roomTitle = createString("roomTitle");

    //inherited
    public final DateTimePath<java.time.LocalDateTime> updatedAt = _super.updatedAt;

    public QRoom(String variable) {
        super(Room.class, forVariable(variable));
    }

    public QRoom(Path<? extends Room> path) {
        super(path.getType(), path.getMetadata());
    }

    public QRoom(PathMetadata metadata) {
        super(Room.class, metadata);
    }

}

