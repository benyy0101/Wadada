package org.api.wadada.app.mypage.Entity;

import jakarta.persistence.*;
import lombok.*;
import org.api.wadada.common.BaseEntity;
import org.locationtech.jts.geom.Point;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;


@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor
@EntityListeners(AuditingEntityListener.class)
@Builder
@Table(name = "single_record")
public class SingleRecord extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "single_record_seq")
    private Integer singleRecordSeq;

    @Column(name = "member_seq", nullable = false)
    private Integer memberSeq;

    // For spatial data type, additional configuration might be required.
    @Column(name = "single_record_start")
    private Point singleRecordStart;

    @Column(name = "single_record_end")
    private Point singleRecordEnd;

    @Column(name = "single_record_time")
    private Integer singleRecordTime;

    @Column(name = "single_record_dist")
    private Integer singleRecordDist;

    @Column(name = "single_record_image")
    private String singleRecordImage;

    // Assuming JSON data is stored as String. Custom converters might be needed for better type handling.
    @Column(name = "single_record_way")
    private String singleRecordWay;

    @Column(name = "single_record_pace")
    private String singleRecordPace;

    @Column(name = "single_record_mean_pace")
    private Integer singleRecordMeanPace;

    @Column(name = "single_record_heartbeat")
    private String singleRecordHeartbeat;

    @Column(name = "single_record_mean_heartbeat")
    private Integer singleRecordMeanHeartbeat;

    @Column(name = "single_record_speed")
    private String singleRecordSpeed;

    @Column(name = "single_record_mean_speed")
    private Integer singleRecordMeanSpeed;

    @Column(name = "single_record_mode")
    private Integer singleRecordMode;


}
