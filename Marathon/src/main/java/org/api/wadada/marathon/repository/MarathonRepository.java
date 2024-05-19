package org.api.wadada.marathon.repository;

import org.api.wadada.marathon.entity.Marathon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MarathonRepository extends JpaRepository<Marathon, Integer>, MarathonCustomRepository {



}
