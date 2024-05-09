package org.api.wadada.multi.entity;

import jakarta.persistence.*;
import lombok.*;
import org.api.wadada.common.BaseEntity;
import org.locationtech.jts.geom.Point;

import java.util.ArrayList;

@Entity
@Getter
@AllArgsConstructor
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

    private Point roomTargetPoint;


    @Column(nullable = false)
    private int roomMaker;

//    @OneToMany(fetch = FetchType.LAZY)
//    private List<MultiRecord> multiRecordList = new ArrayList<>();

    @Builder
    public Room(String roomTitle,int roomPeople, int roomMode, String roomTag,int roomSecret, int roomDist, int roomTime, Point roomTargetPoint, int roomMaker) {
        this.roomTitle = roomTitle;
        this.roomPeople = roomPeople;
        this.roomMode = roomMode;
        this.roomTag = roomTag;
        this.roomSecret = roomSecret;
        this.roomDist = roomDist;
        this.roomTime = roomTime;
        this.roomMaker = roomMaker;
        this.roomTargetPoint = roomTargetPoint;
    }
}
