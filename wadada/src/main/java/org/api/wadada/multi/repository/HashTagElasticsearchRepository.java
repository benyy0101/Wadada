package org.api.wadada.multi.repository;

import org.api.wadada.multi.entity.HashTag;
import org.springframework.data.elasticsearch.annotations.Query;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

public interface HashTagElasticsearchRepository extends ElasticsearchRepository<HashTag,String> {

    @Query("{\"bool\": {\"must\": [{\"match\": {\"roomTag\": \"?0\"}}]}}")
    SearchHits<HashTag> findByRoomTag(String roomTag);

}
