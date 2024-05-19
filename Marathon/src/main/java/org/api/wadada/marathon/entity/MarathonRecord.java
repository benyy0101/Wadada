package org.api.wadada.marathon.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.api.wadada.common.BaseEntity;
import org.locationtech.jts.geom.Point;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Builder
@Table(name = "marathon_record")
public class MarathonRecord extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "marathon_record_seq")
    private Integer marathonRecordSeq;

//    @Column(name = "member_seq", nullable = false)
//    private Integer memberSeq;

    @Column(name = "marathon_seq", nullable = false)
    private Integer marathonSeq;

    @Column(name = "marathon_record_rank")
    private Byte marathonRecordRank;

    // POINT 타입을 처리하는 커스텀 컨버터가 필요할 수 있습니다. 여기서는 예시로 String을 사용했습니다.
    @Column(name = "marathon_record_start", nullable = false)
    private Point marathonRecordStart;

    // JSON 타입을 처리하는 커스텀 컨버터가 필요할 수 있습니다. 여기서는 예시로 String을 사용했습니다.
    @Column(name = "marathon_recode_way")
    private String marathonRecodeWay;

    // POINT 타입을 처리하는 커스텀 컨버터가 필요할 수 있습니다. 여기서는 예시로 String을 사용했습니다.
    @Column(name = "marathon_record_end")
    private Point marathonRecordEnd;

    @Column(name = "marathon_record_dist", nullable = true, columnDefinition = "int default 0")
    private Integer marathonRecordDist;

    @Column(name = "marathon_record_time", nullable = true, columnDefinition = "int default 0")
    private Integer marathonRecordTime;

    @Column(name = "marathon_recode_image")
    private String marathonRecodeImage;

    // JSON 타입을 처리하는 커스텀 컨버터가 필요할 수 있습니다. 여기서는 예시로 String을 사용했습니다.
    @Column(name = "marathon_recode_pace", columnDefinition = "json")
    private String marathonRecodePace;

    @Column(name = "marathon_record_mean_pace", nullable = true, columnDefinition = "int default 0")
    private Integer marathonRecordMeanPace;

    // JSON 타입을 처리하는 커스텀 컨버터가 필요할 수 있습니다. 여기서는 예시로 String을 사용했습니다.
    @Column(name = "marathon_record_speed", columnDefinition = "json")
    private String marathonRecordSpeed;

    @Column(name = "marathon_record_mean_speed", nullable = true, columnDefinition = "int default 0")
    private Integer marathonRecordMeanSpeed;

    // JSON 타입을 처리하는 커스텀 컨버터가 필요할 수 있습니다. 여기서는 예시로 String을 사용했습니다.
    @Column(name = "marathon_record_heartbeat", columnDefinition = "json")
    private String marathonRecordHeartbeat;

    @Column(name = "marathon_record_mean_heartbeat", nullable = true, columnDefinition = "tinyint default 0")
    private Byte marathonRecordMeanHeartbeat;

    @Column(name = "marathon_record_is_win")
    private Boolean marathonRecordIsWin;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_seq")
    private Member member;


    public void updateEnd(Point multiRecordEnd, Integer multiRecordTime,Integer multiRecordDist,String multiRecordImage,Byte multiRecordRank,
                          String multiRecordWay,String multiRecordPace, String multiRecordSpeed,String multiRecordHeartbeat
                            , boolean marathonRecordIsWin){
        this.marathonRecordDist = multiRecordDist;
        this.marathonRecordHeartbeat = multiRecordHeartbeat;
        this.marathonRecordSpeed =  multiRecordSpeed;
        this.marathonRecordEnd = multiRecordEnd;
        this.marathonRecodeImage = multiRecordImage;
        this.marathonRecordTime = multiRecordTime;
        this.marathonRecodeWay = multiRecordWay;
        this.marathonRecodePace = multiRecordPace;
        this.marathonRecordRank = multiRecordRank;
        this.marathonRecordIsWin =marathonRecordIsWin;
    }
    public void updateStart(Point marathonRecordStart){
        this.marathonRecordStart = marathonRecordStart;
    }

//short
    


}