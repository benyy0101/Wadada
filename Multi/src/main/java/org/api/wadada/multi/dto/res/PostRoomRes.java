package org.api.wadada.multi.dto.res;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PostRoomRes {

    private int roomIdx;
    private int roomSeq;

}
