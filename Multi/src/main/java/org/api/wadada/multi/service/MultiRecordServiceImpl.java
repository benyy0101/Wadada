package org.api.wadada.multi.service;

import lombok.AllArgsConstructor;
import org.api.wadada.multi.dto.GameRoomDto;
import org.api.wadada.multi.dto.GameRoomManager;
import org.api.wadada.multi.dto.RoomManager;
import org.api.wadada.multi.dto.req.GameEndReq;
import org.api.wadada.multi.dto.req.GameStartReq;
import org.api.wadada.multi.dto.res.GameEndRes;
import org.api.wadada.multi.dto.res.GameResultRes;
import org.api.wadada.multi.dto.res.GameStartRes;
import org.api.wadada.multi.entity.Member;
import org.api.wadada.multi.entity.MultiRecord;
import org.api.wadada.multi.repository.MemberRepository;
import org.api.wadada.multi.repository.MultiRecordRepository;
import org.hibernate.annotations.Synchronize;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.io.ParseException;
import org.locationtech.jts.io.WKTReader;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.Optional;

@Service
@AllArgsConstructor
public class MultiRecordServiceImpl implements MultiRecordService {
    private final MultiRecordRepository multiRecordRepository;
    private final MemberRepository memberRepository;
    private final RoomManager roomManager;
    private final GameRoomManager gameRoomManager;
    public GameStartRes saveStartMulti(Principal principal, GameStartReq gameStartReq) throws ParseException {
        // 멤버 조회
        Optional<Member> optional = memberRepository.getMemberByMemberId(principal.getName());
        if(optional.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }

//        PointToStringConverter converter = new PointToStringConverter();
//        Point startLocationPoint = converter.convertToEntityAttribute(gameStartReq.getRecordStartLocation());
        WKTReader reader = new WKTReader();
        Point point = (Point) reader.read("POINT (1 1)");

        MultiRecord multiRecord = MultiRecord.builder().multiRecordStart(point)
                .memberSeq(optional.get().getMemberSeq())
                .roomSeq(gameStartReq.getRoomSeq())
                .multiRecordPeople(gameStartReq.getRecordPeople()).build();

        System.out.println("gameRoomManager.getAllRooms().size() = " + gameRoomManager.getAllRooms().values());
        GameRoomDto gameRoomDto = gameRoomManager.getAllRooms().get(gameStartReq.getRoomSeq());
        System.out.println("gameRoomDto = " + gameRoomDto.getRoomSeq());
        gameRoomDto.increasedMember();



        multiRecordRepository.save(multiRecord);



        return new GameStartRes(multiRecord.getMultiRecordSeq());
    }

    public GameEndRes saveEndMulti(Principal principal, GameEndReq gameEndReq){
        // 멤버 조회
        Optional<Member> optionalMember = memberRepository.getMemberByMemberId(principal.getName());
        if(optionalMember.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }

        Optional<MultiRecord> optional = multiRecordRepository.findByMemberIdandRoomSeq(optionalMember.get().getMemberSeq(),gameEndReq.getRoomIdx());
        if(optional.isEmpty()){
            throw new NullPointerException("기록을 찾을 수 없습니다");
        }
        optional.get().updateEnd(gameEndReq.getRecordEndLocation(),gameEndReq.getRecordTime(),gameEndReq.getRecordDist(),
                gameEndReq.getRecordImage(),gameEndReq.getRecordRank(),gameEndReq.getRecordWay(),gameEndReq.getRecordPace(),
                gameEndReq.getRecordSpeed(),gameEndReq.getRecordHeartbeat());

//        PointToStringConverter converter = new PointToStringConverter();
//        Point startLocationPoint = converter.convertToEntityAttribute(gameEndReq.getRecordStartLocation());



        return new GameEndRes(optional.get().getMultiRecordSeq());
    }

    @Override
    public GameResultRes getResultMulti(Principal principal, Integer roomSeq) throws ParseException {
        // 멤버 조회
        Optional<Member> optionalMember = memberRepository.getMemberByMemberId(principal.getName());
        if(optionalMember.isEmpty()){
            throw new NullPointerException("멤버를 찾을 수 없습니다");
        }

        Optional<MultiRecord> optional = multiRecordRepository.findByMemberIdandRoomSeq(optionalMember.get().getMemberSeq(),roomSeq);
        if(optional.isEmpty()){
            throw new NullPointerException("기록을 찾을 수 없습니다");
        }

        MultiRecord multiRecord = optional.get();

        return new GameResultRes(multiRecord.getMultiRecordRank(),multiRecord.getMultiRecordPace(),multiRecord.getMultiRecordImage()
        ,multiRecord.getMultiRecordDist(),multiRecord.getMultiRecordTime(),multiRecord.getMultiRecordStart().toString(),multiRecord.getMultiRecordEnd().toString(),
                multiRecord.getMultiRecordSpeed(),multiRecord.getMultiRecordHeartbeat(),multiRecord.getMultiRecordMeanSpeed(),multiRecord.getMultiRecordMeanPace()
        ,multiRecord.getMultiRecordMeanHeartbeat());
    }


}
