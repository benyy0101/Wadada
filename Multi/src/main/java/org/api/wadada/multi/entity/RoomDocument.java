package org.api.wadada.multi.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
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
@JsonIgnoreProperties(ignoreUnknown = true)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
public class RoomDocument {

    @Id
    private String id;

    @Field(type = FieldType.Integer, name = "room_seq")
    @JsonProperty("room_seq")
    private int roomSeq;

    @Field(type = FieldType.Text,name = "room_title")
    @JsonProperty("room_title")
    private String roomTitle;

    @Field(type = FieldType.Byte, name = "room_people")
    @JsonProperty("room_people")
    private Byte roomPeople;

    @Field(type = FieldType.Byte, name = "room_mode")
    @JsonProperty("room_mode")
    private Byte roomMode;

    @Field(type = FieldType.Text, analyzer = "custom_analyzer", name = "room_tag")
    @JsonProperty("room_tag")
    private String roomTag;

    @Field(type = FieldType.Integer,name = "room_secret")
    @JsonProperty("room_secret")
    private int roomSecret;

    @Field(type = FieldType.Integer,name = "room_dist")
    @JsonProperty("room_dist")
    private int roomDist;

    @Field(type = FieldType.Integer, name = "room_time")
    @JsonProperty("room_time")
    private int roomTime;

    @Field(type = FieldType.Text, name = "room_target")
    @JsonProperty("room_target")
    private String roomTarget;

    @Field(type = FieldType.Integer, name = "room_maker")
    @JsonProperty("room_maker")
    private int roomMaker;

    @Field(type = FieldType.Date, format = {}, pattern = "uuuu-MM-dd'T'HH:mm:ss.SSSX")
//    @JsonProperty("created_at")
    private Date createdAt;

    @Field(type = FieldType.Date, format = {}, pattern = "uuuu-MM-dd'T'HH:mm:ss.SSSSSSSSSX")
//    @JsonProperty("@timestamp")
    private Instant timestamp;

    @Field(type = FieldType.Boolean, name = "is_deleted")
    @JsonProperty("is_deleted")
    private Boolean isDeleted;

//    @JsonProperty("updated_at")
    @Field(type = FieldType.Date,name = "updated_at" , format = {}, pattern = "uuuu-MM-dd'T'HH:mm:ss.SSSX")
    private Date updatedAt;

    @GeoPointField
    @Field(name = "room_target_point")
    @JsonProperty("room_target_point")
    private GeoPoint roomTargetPoint;

    @JsonProperty("@version")
    private String version;

}
