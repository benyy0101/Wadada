package org.api.wadada.multi.dto.res;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AttendRoomRes {

    private String memberNickname;
    private String memberGender;
    private String memberProfileImage;
    private int memberLevel;

}
