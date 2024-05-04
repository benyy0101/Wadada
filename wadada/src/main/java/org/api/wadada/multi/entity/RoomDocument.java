package org.api.wadada.multi.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import org.springframework.data.annotation.Version;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;
import org.springframework.data.elasticsearch.annotations.GeoPointField;
import org.springframework.data.elasticsearch.core.geo.GeoPoint;

import java.time.Instant;
import java.util.Date;
@Document(indexName = "room")
@Getter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
public class RoomDocument {

    @Id
    private String id;

    @Field(type = FieldType.Integer, name = "room_seq")
    private int roomSeq;

    @Field(type = FieldType.Text,name = "room_title")
    private String roomTitle;

    @Field(type = FieldType.Byte, name = "room_people")
    private Byte roomPeople;

    @Field(type = FieldType.Byte, name = "room_mode")
    private Byte roomMode;

    @Field(type = FieldType.Text, analyzer = "custom_analyzer", name = "room_tag")
    private String roomTag;

    @Field(type = FieldType.Integer,name = "room_secret")
    private int roomSecret;

    @Field(type = FieldType.Integer,name = "room_dist")
    private int roomDist;

    @Field(type = FieldType.Integer, name = "room_time")
    private int roomTime;

    @Field(type = FieldType.Text, name = "room_target")
    private String roomTarget;

    @Field(type = FieldType.Integer, name = "room_maker")
    private int roomMaker;

    @Field(type = FieldType.Date, format = {}, pattern = "uuuu-MM-dd'T'HH:mm:ss.SSSX")
    private Date createdAt;

    @Field(type = FieldType.Date, format = {}, pattern = "uuuu-MM-dd'T'HH:mm:ss.SSSSSSSSSX")
    private Instant timestamp;

    @Field(type = FieldType.Boolean, name = "is_deleted")
    private Boolean isDeleted;

    @Field(type = FieldType.Date,name = "updated_at" , format = {}, pattern = "uuuu-MM-dd'T'HH:mm:ss.SSSX")
    private Date updatedAt;

    @GeoPointField
    private GeoPoint roomTargetPoint;

    @JsonProperty("@version")
    private String version;

}
