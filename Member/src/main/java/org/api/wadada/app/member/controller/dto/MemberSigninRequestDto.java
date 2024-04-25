package org.api.wadada.app.member.controller.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.joda.time.DateTime;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class MemberSigninRequestDto {

    public MemberSigninRequestDto(String memberNickName, DateTime memberBirthday, String memberGender, String memberMainEmail, String memberProfileImage, Integer memberExp, Integer memberTotalDist, Integer memberTotalTime, byte memberLevel) {
        this.memberNickName = memberNickName;
        this.memberBirthday = memberBirthday;
        this.memberGender = memberGender;
        this.memberMainEmail = memberMainEmail;
        this.memberProfileImage = memberProfileImage;
        this.memberExp = memberExp;
        this.memberTotalDist = memberTotalDist;
        this.memberTotalTime = memberTotalTime;
        this.memberLevel = memberLevel;
    }

    private String memberNickName;
    private DateTime memberBirthday;
    private String memberGender;
    private String memberMainEmail;
    private String memberProfileImage;
    private Integer memberExp;
    private Integer memberTotalDist;
    private Integer memberTotalTime;
    private byte memberLevel;
    @Setter
    public List<String> roles;


}
