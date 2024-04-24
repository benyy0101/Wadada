package org.api.wadada.single.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.joda.time.DateTime;

import java.awt.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class SingleRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int singleRecordId;

    @ManyToOne(fetch = FetchType.LAZY)
    private Member memberSeq;

    @Column(nullable = false)
    private Point singleRecordStart;

    private Point singleRecordEnd;

    private int singleRecordTime;

    private int singleRecordDist;

    private String singleRecordImage;

    private String singleRecordWay;

    private String singleRecordPace;

    private int singleRecordMeanPace;

    private String singleRecordHeartbeat;

    private int singleRecordMeanHeartbeat;

    private String singleRecordSpeed;

    private int singleRecordMeanSpeed;

    @Column(nullable = false)
    private DateTime createdAt;

    @Column(nullable = false)
    private DateTime isDeleted;

    @Column(nullable = false)
    private DateTime updatedAt;

}
