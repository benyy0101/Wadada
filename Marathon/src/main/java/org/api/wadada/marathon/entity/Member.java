package org.api.wadada.marathon.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.api.wadada.common.BaseEntity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;


import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import static lombok.AccessLevel.PROTECTED;

@Entity
@Getter
@NoArgsConstructor(access = PROTECTED)
@AllArgsConstructor
@Builder
@Table(name = "member")
public class Member extends BaseEntity implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="member_seq", updatable = false, unique = true, nullable = false)
    private int memberSeq;

    @Column(name="member_id", updatable = false, unique = true, nullable = false)
    private String memberId;

    @Column(name = "member_nickname",nullable = false)
    private String memberNickName;

    @Column(name = "member_birthday",nullable = false)

    private LocalDate memberBirthday;

    @Column(name = "member_gender",nullable = false)
    private String memberGender;

    @Column(name = "member_main_email",nullable = false)
    private String memberMainEmail;

    @Column(name = "member_profile_image",nullable = false)
    private String memberProfileImage;

    @Column(name = "member_exp",nullable = false)
    private Integer memberExp;

    @Column(name = "member_total_dist",nullable = false)
    private Integer memberTotalDist;

    @Column(name = "member_total_time",nullable = false)
    private Integer memberTotalTime;

    @Column(name = "member_level",nullable = false)
    private Byte memberLevel;

    @Builder.Default
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "member_role", joinColumns = @JoinColumn(name = "member_id"))
    private List<String> roles = new ArrayList<>();

    public void delete(){
        deleteSoftly();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return this.roles.stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());
    }

    @Override
    public String getPassword() {
        return getMemberId();
    }

    @Override
    public String getUsername() {
        return this.memberId;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
