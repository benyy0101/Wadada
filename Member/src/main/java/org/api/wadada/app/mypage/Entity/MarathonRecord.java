package org.api.wadada.app.mypage.Entity;

import jakarta.persistence.*;
import lombok.*;
import org.api.wadada.common.BaseEntity;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.awt.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
@Table(name = "marathon_record")
public class MarathonRecord extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "marathon_record_seq")
    private Integer marathonRecordSeq;

    @Column(name = "member_seq", nullable = false)
    private Integer memberSeq;

    @Column(name = "marathon_seq", nullable = false)
    private Integer marathonSeq;

    @Column(name = "marathon_record_start", columnDefinition = "Point", nullable = false)
    private Point marathonRecordStart;

    @Column(name = "marathon_recode_way")
    private String marathonRecodeWay;

    @Column(name = "marathon_record_end", columnDefinition = "Point")
    private Point marathonRecordEnd;

    @Column(name = "marathon_record_dist")
    private Integer marathonRecordDist;

    @Column(name = "marathon_record_time")
    private Integer marathonRecordTime;

    @Column(name = "marathon_recode_image")
    private String marathonRecodeImage;

    @Column(name = "marathon_recode_pace")
    private String marathonRecodePace;

    @Column(name = "marathon_record_mean_pace")
    private Integer marathonRecordMeanPace;

    @Column(name = "marathon_record_speed")
    private String marathonRecordSpeed;

    @Column(name = "marathon_record_mean_speed")
    private Integer marathonRecordMeanSpeed;

    @Column(name = "marathon_record_heartbeat")
    private String marathonRecordHeartbeat;

    @Column(name = "marathon_record_mean_heartbeat")
    private Integer marathonRecordMeanHeartbeat;

    @Column(name = "marathon_record_is_win", nullable = false)
    private Boolean marathonRecordIsWin;

}
