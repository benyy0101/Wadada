package org.api.wadada.app.mypage.Entity;

import jakarta.persistence.*;
import lombok.*;
import org.api.wadada.common.BaseEntity;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import java.awt.Point;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
@Table(name = "multi_record")
public class MultiRecord extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "multi_record_seq")
    private Integer multiRecordSeq;

    @Column(name = "room_seq", nullable = false)
    private Integer roomSeq;

    @Column(name = "member_seq", nullable = false)
    private Integer memberSeq;

    @Column(name = "multi_record_start", columnDefinition = "Point", nullable = false)
    private Point multiRecordStart;

    @Column(name = "multi_record_end", columnDefinition = "Point")
    private Point multiRecordEnd;

    @Column(name = "multi_record_time", nullable = true)
    private Integer multiRecordTime;

    @Column(name = "multi_record_dist", nullable = true)
    private Integer multiRecordDist;

    @Column(name = "multi_record_image", length = 100)
    private String multiRecordImage;

    @Column(name = "multi_record_rank", nullable = true)
    private Byte multiRecordRank;

    // Assuming JSON data is stored as String. Custom converters might be needed for better type handling.
    @Column(name = "multi_record_way")
    private String multiRecordWay;

    @Column(name = "multi_record_pace")
    private String multiRecordPace;

    @Column(name = "multi_record_speed")
    private String multiRecordSpeed;

    @Column(name = "multi_record_heartbeat")
    private String multiRecordHeartbeat;

    @Column(name = "multi_record_people", nullable = true)
    private Byte multiRecordPeople;

    @Column(name = "multi_record_mean_pace", nullable = true)
    private Integer multiRecordMeanPace;

    @Column(name = "multi_record_mean_speed", nullable = true)
    private Integer multiRecordMeanSpeed;

    @Column(name = "multi_record_mean_heartbeat", nullable = true)
    private Byte multiRecordMeanHeartbeat;
}
