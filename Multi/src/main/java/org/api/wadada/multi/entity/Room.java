package org.api.wadada.multi.entity;

import jakarta.persistence.*;
import lombok.*;
import org.api.wadada.common.BaseEntity;
import org.geolatte.geom.Point;

import java.util.ArrayList;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@AllArgsConstructor
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


}
