package org.api.wadada.multi.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.api.wadada.common.BaseEntity;
import org.locationtech.jts.geom.Point;

import java.util.ArrayList;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Room extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int roomSeq;

    @Column(nullable = false)
    private String roomTitle;

    @Column(nullable = false)
    private int roomPeople;

    @Column(nullable = false)
    private int roomMode;

    private String roomTag;

    private int roomSecret;

    private int roomDist;

    private int roomTime;

    private String roomTarget;

    private Point roomTargetPoint;

    @Column(nullable = false)
    private int roomMaker;

//    @OneToMany(fetch = FetchType.LAZY)
//    private List<MultiRecord> multiRecordList = new ArrayList<>();

    @Builder
    public Room(String roomTitle,int roomPeople, int roomMode, String roomTag,int roomSecret, int roomDist, int roomTime, String roomTarget, Point roomTargetPoint, int roomMaker) {
        this.roomTitle = roomTitle;
        this.roomPeople = roomPeople;
        this.roomMode = roomMode;
        this.roomTag = roomTag;
        this.roomSecret = roomSecret;
        this.roomDist = roomDist;
        this.roomTime = roomTime;
        this.roomTarget = roomTarget;
        this.roomTargetPoint = roomTargetPoint;
        this.roomMaker = roomMaker;
    }
}
