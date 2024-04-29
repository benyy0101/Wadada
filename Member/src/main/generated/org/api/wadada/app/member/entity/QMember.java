package org.api.wadada.app.member.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QMember is a Querydsl query type for Member
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QMember extends EntityPathBase<Member> {

    private static final long serialVersionUID = -1368913462L;

    public static final QMember member = new QMember("member1");

    public final org.api.wadada.common.QBaseEntity _super = new org.api.wadada.common.QBaseEntity(this);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> createdAt = _super.createdAt;

    //inherited
    public final BooleanPath isDeleted = _super.isDeleted;

    public final DatePath<java.time.LocalDate> memberBirthday = createDate("memberBirthday", java.time.LocalDate.class);

    public final NumberPath<Integer> memberExp = createNumber("memberExp", Integer.class);

    public final StringPath memberGender = createString("memberGender");

    public final StringPath memberId = createString("memberId");

    public final NumberPath<Byte> memberLevel = createNumber("memberLevel", Byte.class);

    public final StringPath memberMainEmail = createString("memberMainEmail");

    public final StringPath memberNickName = createString("memberNickName");

    public final StringPath memberPassword = createString("memberPassword");

    public final StringPath memberProfileImage = createString("memberProfileImage");

    public final NumberPath<Integer> memberSeq = createNumber("memberSeq", Integer.class);

    public final NumberPath<Integer> memberTotalDist = createNumber("memberTotalDist", Integer.class);

    public final NumberPath<Integer> memberTotalTime = createNumber("memberTotalTime", Integer.class);

    public final ListPath<String, StringPath> roles = this.<String, StringPath>createList("roles", String.class, StringPath.class, PathInits.DIRECT2);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> updatedAt = _super.updatedAt;

    public QMember(String variable) {
        super(Member.class, forVariable(variable));
    }

    public QMember(Path<? extends Member> path) {
        super(path.getType(), path.getMetadata());
    }

    public QMember(PathMetadata metadata) {
        super(Member.class, metadata);
    }

}

