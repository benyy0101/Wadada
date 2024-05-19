package org.api.wadada.marathon.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class FlagPointRes {

    private double latitude;
    private double longitude;
}
