package org.api.wadada.multi.dto.res;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AttendRoomRes {

    private String type;
    private String memberNickname;
    private String memberId;
    private String memberGender;
    private String memberProfileImage;
    private int memberLevel;

}
