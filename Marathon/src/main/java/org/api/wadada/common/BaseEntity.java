package org.api.wadada.common;


import jakarta.persistence.*;
import jakarta.transaction.Transactional;
import lombok.Getter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@EntityListeners(AuditingEntityListener.class)
@Getter
@MappedSuperclass
public class BaseEntity {

    @CreatedDate
    @Column(updatable = false, name = "created_at")
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "is_deleted")
    private Boolean isDeleted = Boolean.FALSE;

    @PrePersist // 엔티티가 영속성 컨텍스트에 저장되기 전에 실행
    private void prePersist() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
            this.updatedAt = LocalDateTime.now();
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now(); // 객체 업데이트 시, 현재 시각으로 업데이트
    }

    public void deleteSoftly() {
        System.out.println("소프트딜리트 실행됨");
        this.isDeleted = Boolean.TRUE;
        updatedAt = LocalDateTime.now();
    }

    public void undoDeletion() {
        this.isDeleted = Boolean.FALSE;
    }
}

