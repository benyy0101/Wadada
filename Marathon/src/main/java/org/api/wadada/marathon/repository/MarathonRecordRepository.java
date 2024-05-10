package org.api.wadada.marathon.repository;

import org.api.wadada.marathon.entity.MarathonRecord;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MarathonRecordRepository extends JpaRepository<MarathonRecord, Integer>{
}
