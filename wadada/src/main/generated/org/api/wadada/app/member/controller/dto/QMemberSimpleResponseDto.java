package org.api.wadada.app.member.controller.dto;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.ConstructorExpression;
import javax.annotation.processing.Generated;

/**
 * org.api.wadada.app.member.controller.dto.QMemberSimpleResponseDto is a Querydsl Projection type for MemberSimpleResponseDto
 */
@Generated("com.querydsl.codegen.DefaultProjectionSerializer")
public class QMemberSimpleResponseDto extends ConstructorExpression<MemberSimpleResponseDto> {

    private static final long serialVersionUID = -1393470516L;

    public QMemberSimpleResponseDto(com.querydsl.core.types.Expression<String> memberId, com.querydsl.core.types.Expression<String> nickname, com.querydsl.core.types.Expression<String> profileImage) {
        super(MemberSimpleResponseDto.class, new Class<?>[]{String.class, String.class, String.class}, memberId, nickname, profileImage);
    }

}

