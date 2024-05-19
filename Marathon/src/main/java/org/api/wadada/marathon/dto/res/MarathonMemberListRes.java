package org.api.wadada.marathon.dto.res;

import lombok.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MarathonMemberListRes {
    private String memberName;
    private String memberImage;
}
