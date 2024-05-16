package org.api.wadada.marathon.dto.req;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RabbitRequestDataReq {
    private int roomSeq;
    private String userName;
    private int userDist;
    private int userTime;

    private int memberSeq;
}
