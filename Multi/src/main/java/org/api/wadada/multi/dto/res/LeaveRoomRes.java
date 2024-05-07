package org.api.wadada.multi.dto.res;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class LeaveRoomRes {

    private String memberId;
    private String type;

}
