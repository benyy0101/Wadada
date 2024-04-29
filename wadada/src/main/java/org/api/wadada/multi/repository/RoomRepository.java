package org.api.wadada.multi.repository;

import jakarta.transaction.Transactional;
import org.api.wadada.multi.entity.Room;
import org.api.wadada.single.entity.SingleRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoomRepository extends JpaRepository<Room, Integer> {


}
