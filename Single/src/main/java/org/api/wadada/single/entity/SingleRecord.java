package org.api.wadada.single.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class SingleRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "single_record_seq")
    private int singleRecordSeq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_seq")
    private Member member;

    @Column(nullable = false)
    private Point singleRecordStart;

    private Point singleRecordEnd;

    private int singleRecordTime;

    private int singleRecordDist;

    private String singleRecordImage;

    private String singleRecordWay;

    // 페이스
    private String singleRecordPace;

    private int singleRecordMeanPace;

    //심박수
    private String singleRecordHeartbeat;

    private int singleRecordMeanHeartbeat;

    //속도
    private String singleRecordSpeed;

    private int singleRecordMeanSpeed;

    private int singleRecordMode;
    // 거리 1 속도2

    @CreatedDate
    @Column(name = "created_at",nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "is_deleted",nullable = false)
    private int isDeleted;


    @LastModifiedDate
    @Column(name = "updated_at",nullable = false)
    private LocalDateTime updatedAt;

    @Builder
    public SingleRecord( Member member, Point singleRecordStart, Point singleRecordEnd, int singleRecordTime, int singleRecordDist,
                        String singleRecordImage, String singleRecordWay, String singleRecordPace, int singleRecordMeanPace,
                        String singleRecordHeartbeat, int singleRecordMeanHeartbeat, String singleRecordSpeed,
                        int singleRecordMeanSpeed, int singleRecordMode, int isDeleted) {
        this.member = member;
        this.singleRecordStart = singleRecordStart;
        this.singleRecordEnd = singleRecordEnd;
        this.singleRecordTime = singleRecordTime;
        this.singleRecordDist = singleRecordDist;
        this.singleRecordImage = singleRecordImage;
        this.singleRecordWay = singleRecordWay;
        this.singleRecordPace = singleRecordPace;
        this.singleRecordMeanPace = singleRecordMeanPace;
        this.singleRecordHeartbeat = singleRecordHeartbeat;
        this.singleRecordMeanHeartbeat = singleRecordMeanHeartbeat;
        this.singleRecordSpeed = singleRecordSpeed;
        this.singleRecordMeanSpeed = singleRecordMeanSpeed;
        this.singleRecordMode = singleRecordMode;
        this.isDeleted = isDeleted;
    }

    public void updateEnd(Point singleRecordStart, Point singleRecordEnd, int singleRecordTime, int singleRecordDist,
                          String singleRecordImage, String singleRecordWay, String singleRecordPace, int singleRecordMeanPace,
                          String singleRecordHeartbeat, int singleRecordMeanHeartbeat, String singleRecordSpeed,
                          int singleRecordMeanSpeed){
        this.singleRecordStart = singleRecordStart;
        this.singleRecordEnd = singleRecordEnd;
        this.singleRecordTime = singleRecordTime;
        this.singleRecordDist = singleRecordDist;
        this.singleRecordImage = singleRecordImage;
        this.singleRecordWay = singleRecordWay;
        this.singleRecordPace = singleRecordPace;
        this.singleRecordMeanPace = singleRecordMeanPace;
        this.singleRecordHeartbeat = singleRecordHeartbeat;
        this.singleRecordMeanHeartbeat = singleRecordMeanHeartbeat;
        this.singleRecordSpeed = singleRecordSpeed;
        this.singleRecordMeanSpeed = singleRecordMeanSpeed;

    }
    public void delete(){
        this.isDeleted = 1;
    }

}
