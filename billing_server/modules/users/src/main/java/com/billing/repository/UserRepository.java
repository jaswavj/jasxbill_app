package com.billing.repository;

import com.billing.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUserNameAndIsActive(String userName, Integer isActive);

    @Query(value = """
            SELECT DISTINCT module_id FROM (
              SELECT p.module_id AS module_id
              FROM user_permission p
              JOIN user_modules m ON m.id = p.module_id AND IFNULL(m.is_active, 1) = 1
              LEFT JOIN user_modules g0 ON g0.id = m.group_id
              WHERE p.uid = :userId
                AND (IFNULL(m.is_group, 1) = 1 OR IFNULL(m.group_id, 0) = 0 OR IFNULL(g0.is_active, 1) = 1)
              UNION
              SELECT c.id
              FROM user_permission p
              JOIN user_modules g ON g.id = p.module_id AND IFNULL(g.is_group, 1) = 1 AND IFNULL(g.is_active, 1) = 1
              JOIN user_modules c ON c.group_id = g.id AND IFNULL(c.is_group, 0) = 0 AND IFNULL(c.is_active, 1) = 1
              WHERE p.uid = :userId
                AND NOT EXISTS (
                  SELECT 1 FROM user_permission p2
                  JOIN user_modules c2 ON c2.id = p2.module_id AND c2.group_id = g.id AND IFNULL(c2.is_group, 0) = 0
                  WHERE p2.uid = :userId
                )
              UNION
              SELECT c.group_id
              FROM user_permission p
              JOIN user_modules c ON c.id = p.module_id AND IFNULL(c.is_group, 0) = 0 AND IFNULL(c.group_id, 0) > 0 AND IFNULL(c.is_active, 1) = 1
              JOIN user_modules g ON g.id = c.group_id AND IFNULL(g.is_active, 1) = 1
              WHERE p.uid = :userId
            ) x
            """, nativeQuery = true)
    List<Number> findModuleIdsByUserId(@Param("userId") Long userId);

    @Query(value = "SELECT module_id FROM user_permission WHERE uid = :userId", nativeQuery = true)
    List<Number> findRawModuleIdsByUserId(@Param("userId") Long userId);
}
