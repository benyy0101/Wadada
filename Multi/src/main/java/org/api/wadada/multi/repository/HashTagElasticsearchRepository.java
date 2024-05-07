package org.api.wadada.multi.repository;

import org.api.wadada.multi.entity.HashTag;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Query;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import java.util.List;

public interface HashTagElasticsearchRepository extends ElasticsearchRepository<HashTag,String> {

    @Query("{\"match_all\": {}}")
    List<HashTag> findByRoomTag(String roomTag);


}
