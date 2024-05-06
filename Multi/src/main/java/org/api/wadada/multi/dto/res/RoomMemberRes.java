package org.api.wadada.multi.dto.res;


import lombok.Builder;
import lombok.Data;
import org.api.wadada.multi.entity.Member;

@Data
@Builder
// 프론트 response
public class RoomMemberRes {

    private boolean isManager;
    private String memberNickname;
    private String memberId;
    private String memberGender;
    private String memberProfileImage;
    private int memberLevel;
    private boolean memberReady = false;

    public void changeReady(){
        this.memberReady = !this.memberReady;
    }

    public static RoomMemberRes of(boolean isManager,Member member){
        return RoomMemberRes.builder()
                .isManager(isManager)
                .memberNickname(member.getMemberNickName())
                .memberId(member.getMemberId())
                .memberGender(member.getMemberGender())
                .memberProfileImage(member.getMemberProfileImage())
                .memberLevel(member.getMemberLevel())
                .build();
    }

}