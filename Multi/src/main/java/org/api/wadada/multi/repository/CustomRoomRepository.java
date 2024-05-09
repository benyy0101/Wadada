package org.api.wadada.multi.repository;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.elasticsearch._types.query_dsl.FuzzyQuery;
import co.elastic.clients.elasticsearch._types.query_dsl.QueryBuilders;
import co.elastic.clients.elasticsearch.core.SearchRequest;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.AllArgsConstructor;
import org.api.wadada.multi.entity.QRoom;
import org.api.wadada.multi.entity.RoomDocument;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import co.elastic.clients.elasticsearch._types.query_dsl.Query;
import org.springframework.stereotype.Repository;
import co.elastic.clients.elasticsearch._types.query_dsl.BoolQuery;
import java.util.List;
import java.util.stream.Collectors;

@Repository
public class CustomRoomRepository {

    private final ElasticsearchOperations elasticsearchOperations;
    private ElasticsearchClient client;

    private final JPAQueryFactory jpaQueryFactory;

    @Autowired
    public CustomRoomRepository(ElasticsearchOperations elasticsearchOperations, ElasticsearchClient client, JPAQueryFactory jpaQueryFactory) {
        this.elasticsearchOperations = elasticsearchOperations;
        this.client = client;
        this.jpaQueryFactory = jpaQueryFactory;
    }

    public List<RoomDocument> findByRoomTags(String[] tags) {

        ///  bool 쿼리 테스트
        BoolQuery.Builder boolQueryBuilder = QueryBuilders.bool();
        for (String tag : tags) {
            FuzzyQuery fuzzyQuery = FuzzyQuery.of(f -> f
                    .field("room_tag")
                    .value(tag)
                    .fuzziness("1") // 필요에 따라 fuzziness 설정 가능
            );
            boolQueryBuilder.must(Query.of(q -> q.fuzzy(fuzzyQuery)));
        }

        // BoolQuery를 Query 객체로 변환
        Query query = Query.of(q -> q.bool(boolQueryBuilder.build()));
        SearchRequest searchRequest = SearchRequest.of(s -> s
                .index("room")
                .query(query));
        try {
            SearchResponse<RoomDocument> response = client.search(searchRequest, RoomDocument.class);
            return response.hits().hits().stream()
                    .map(hit -> hit.source())
                    .collect(Collectors.toList());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


}
