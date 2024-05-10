package org.api.wadada.multi.repository;

import org.api.wadada.multi.entity.RoomDocument;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoomDocumentRepository extends ElasticsearchRepository<RoomDocument, String> {


}
