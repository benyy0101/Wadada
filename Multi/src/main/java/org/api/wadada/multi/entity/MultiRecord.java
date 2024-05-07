package org.api.wadada.multi.entity;

import jakarta.persistence.*;
import lombok.*;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "multi_record")
public class MultiRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "multi_record_seq")
    private Integer multiRecordSeq;

    @Column(name = "room_seq", nullable = false)
    private Integer roomSeq;

    @Column(name = "member_seq", nullable = false)
    private Integer memberSeq;

    @Column(name = "multi_record_start", nullable = false, columnDefinition = "Point")
    private Point multiRecordStart;

    @Column(name = "multi_record_end", columnDefinition = "Point")
    private Point multiRecordEnd;

    @Column(name = "multi_record_time", columnDefinition = "int default 0")
    private Integer multiRecordTime;

    @Column(name = "multi_record_dist", columnDefinition = "int default 0")
    private Integer multiRecordDist;

    @Column(name = "multi_record_image")
    private String multiRecordImage;

    @Column(name = "multi_record_rank", columnDefinition = "tinyint default 1")
    private Integer multiRecordRank;

    // JSON 타입의 필드 처리는 실제 사용하는 JPA 구현체에 맞게 적절한 변환기를 적용해야 합니다.
    @Column(name = "multi_record_way")
    private String multiRecordWay;

    @Column(name = "multi_record_pace")
    private String multiRecordPace;

    @Column(name = "multi_record_speed")
    private String multiRecordSpeed;

    @Column(name = "multi_record_heartbeat")
    private String multiRecordHeartbeat;

    @Column(name = "multi_record_people")
    private Integer multiRecordPeople;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "is_deleted", nullable = false)
    private Boolean isDeleted;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "multi_record_mean_pace")
    private Integer multiRecordMeanPace;

    @Column(name = "multi_record_mean_speed")
    private Integer multiRecordMeanSpeed;

    @Column(name = "multi_record_mean_heartbeat")
    private Integer multiRecordMeanHeartbeat;

    //추가사항 모드
    @Column(name = "multi_record_mode")
    private String recordMode;

    public void updateEnd(Point multiRecordEnd, Integer multiRecordTime,Integer multiRecordDist,String multiRecordImage,Integer multiRecordRank,
                          String multiRecordWay,String multiRecordPace, String multiRecordSpeed,String multiRecordHeartbeat){
        this.multiRecordDist = multiRecordDist;
        this.multiRecordHeartbeat = multiRecordHeartbeat;
        this.multiRecordSpeed =  multiRecordSpeed;
        this.multiRecordEnd = multiRecordEnd;
        this.multiRecordImage = multiRecordImage;
        this.multiRecordTime = multiRecordTime;
        this.multiRecordWay = multiRecordWay;
        this.multiRecordPace = multiRecordPace;
        this.multiRecordRank = multiRecordRank;
    }
}