package org.api.wadada.multi.dto.res;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.HashMap;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class CreateRoomRes {
    private int roomSeq;
    List<RoomMemberRes> RoomResponse;
}
