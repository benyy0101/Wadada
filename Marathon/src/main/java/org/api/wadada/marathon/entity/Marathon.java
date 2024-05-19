package org.api.wadada.marathon.entity;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.api.wadada.common.BaseEntity;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Entity
@Builder
@Getter
@Table(name = "marathon")
public class Marathon extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "marathon_seq")
    private int marathonSeq;

    @Column(name = "marathon_round", nullable = false)
    private short marathonRound;

    @Column(name = "marathon_title", nullable = false, length = 30)
    private String marathonTitle;

    @Column(name = "marathon_participate", nullable = false)
    private int marathonParticipate;

    @Column(name = "marathon_goal", nullable = false)
    private short marathonGoal;


    @Column(name = "marathon_type", nullable = false)
    private Byte marathonType; // MarathonType은 별도의 enum 클래스 필요

    @Column(name = "marathon_text", nullable = false, length = 100)
    private String marathonText;

    @Column(name = "marathon_dist", nullable = false)
    private int marathonDist;

    @Column(name = "marathon_start", nullable = false)
    private LocalDateTime marathonStart;

    @Column(name = "marathon_end", nullable = false)
    private LocalDateTime marathonEnd;

}