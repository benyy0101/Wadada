package org.api.wadada.multi.entity;

import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Version;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;
import org.springframework.data.elasticsearch.annotations.Setting;

import java.time.Instant;

@Getter
@Setter
@Document(indexName = "tag")
@Setting(replicas = 0)
public class HashTag {

    @Id
    private String id;

    @Field(type = FieldType.Text ,analyzer = "nori")
    private String roomTag;

    @Field(type = FieldType.Boolean)
    private boolean isDeleted;

    @Version
    private Long version;

    @Field(type = FieldType.Date, format = {}, pattern = "uuuu-MM-dd'T'HH:mm:ss.SSSSSSSSSX")
    private Instant timestamp;

    @Field(type = FieldType.Integer)
    private Integer roomSeq;

}
