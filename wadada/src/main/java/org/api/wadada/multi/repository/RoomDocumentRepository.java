package org.api.wadada.multi.repository;


import co.elastic.clients.elasticsearch.ElasticsearchClient;
//import co.elastic.clients.elasticsearch._types.query_dsl.Query;
import co.elastic.clients.elasticsearch.core.SearchRequest;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import co.elastic.clients.elasticsearch.core.search.Hit;
import org.api.wadada.multi.entity.RoomDocument;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.annotations.Query;
import org.springframework.data.elasticsearch.client.elc.*;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.mapping.IndexCoordinates;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Repository
public interface RoomDocumentRepository extends ElasticsearchRepository<RoomDocument, String> {

    // 조건 검색 쿼리  fuzziness 레벨에 따라 범위 좁혀짐
    @Query("""
        {
          "bool": {
            "must": [
              {
                "term": {
                  "is_deleted": {
                    "value": false
                  }
                }
              }
            ],
            "should": [
              {
                "match": {
                  "room_tag": "?0"
                }
              },
              {
                "fuzzy": {
                  "room_tag": {
                    "value": "?0",
                    "fuzziness": "1"
                  }
                }
              }
            ]
          }
        }
        """)
    List<RoomDocument> findByRoomTag(String tag);


}


//@Repository
//public class RoomDocumentRepository {
//
//    private final ElasticsearchClient elasticsearchClient;
//
//    @Autowired
//    public RoomDocumentRepository(ElasticsearchClient elasticsearchClient) {
//        this.elasticsearchClient = elasticsearchClient;
//    }
//
//    public List<RoomDocument> getRoomsByTag(String tag) throws IOException {
//        SearchRequest searchRequest = SearchRequest.of(sr -> sr
//                .index("room")
//                .query(q -> q
//                        .bool(b -> b
//                                .should(s -> s.match(m -> m.field("room_tag").query(tag)))
//                                .should(s -> s.fuzzy(f -> f.field("room_tag").value(tag).fuzziness("AUTO")))
//                        )
//                ));
//
//        SearchResponse<RoomDocument> response = elasticsearchClient.search(searchRequest, RoomDocument.class);
//
//        return response.hits().hits()
//                .stream()
//                .map(Hit::source)
//                .collect(Collectors.toList());
//    }
//}
