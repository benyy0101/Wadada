-- --------------------------------------------------------
-- 호스트:                          54.180.195.204
-- 서버 버전:                        8.4.0 - MySQL Community Server - GPL
-- 서버 OS:                        Linux
-- HeidiSQL 버전:                  12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- 테이블 wadada.challenge_course 구조 내보내기
CREATE TABLE IF NOT EXISTS `challenge_course` (
  `challenge_course_seq` smallint NOT NULL AUTO_INCREMENT,
  `challenge_course_start` point NOT NULL,
  `challenge_course_end` point NOT NULL,
  `challenge_course_dist` int NOT NULL DEFAULT '0',
  `challenge_course_name` varchar(30) NOT NULL,
  `challenge_course_way` json DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`challenge_course_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 테이블 데이터 wadada.challenge_course:~0 rows (대략적) 내보내기

-- 테이블 wadada.challenge_record 구조 내보내기
CREATE TABLE IF NOT EXISTS `challenge_record` (
  `challenge_record_seq` int NOT NULL,
  `member_seq` int NOT NULL,
  `challenge_course_seq` smallint NOT NULL,
  `challenge_course_dist` int DEFAULT '0',
  `challenge_course_time` int DEFAULT '0',
  `challenge_course_image` varchar(100) DEFAULT NULL,
  `challenge_course_way` json DEFAULT NULL COMMENT 'JSON',
  `challenge_course_pace` json DEFAULT NULL,
  `challenge_record_mean_pace` int DEFAULT '0',
  `challenge_course_speed` json DEFAULT NULL COMMENT 'JSON',
  `challenge_record_mean_speed` int DEFAULT '0',
  `challenge_course_heartbeat` json DEFAULT NULL COMMENT 'JSON',
  `challenge_record_mean_heartbeat` tinyint DEFAULT '0',
  `challenge_record_is_ok` tinyint(1) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`challenge_record_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 테이블 데이터 wadada.challenge_record:~0 rows (대략적) 내보내기

-- 테이블 wadada.landmark 구조 내보내기
CREATE TABLE IF NOT EXISTS `landmark` (
  `landmark_seq` int NOT NULL AUTO_INCREMENT,
  `landmark_point` point DEFAULT NULL,
  `landmark_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`landmark_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 테이블 데이터 wadada.landmark:~9 rows (대략적) 내보내기

-- 테이블 wadada.marathon 구조 내보내기
CREATE TABLE IF NOT EXISTS `marathon` (
  `marathon_seq` int NOT NULL AUTO_INCREMENT,
  `marathon_round` smallint NOT NULL,
  `marathon_title` varchar(30) NOT NULL,
  `marathon_participate` int NOT NULL DEFAULT '0',
  `marathon_goal` smallint NOT NULL DEFAULT '0',
  `marathon_type` tinyint NOT NULL COMMENT 'enum',
  `marathon_text` varchar(100) NOT NULL,
  `marathon_dist` int NOT NULL DEFAULT '0',
  `marathon_start` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `marathon_end` datetime NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`marathon_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 테이블 데이터 wadada.marathon:~27 rows (대략적) 내보내기


-- 테이블 wadada.marathon_record 구조 내보내기
CREATE TABLE IF NOT EXISTS `marathon_record` (
  `marathon_record_seq` int NOT NULL AUTO_INCREMENT,
  `member_seq` int NOT NULL,
  `marathon_seq` int NOT NULL,
  `marathon_record_rank` tinyint DEFAULT NULL,
  `marathon_record_start` point DEFAULT NULL,
  `marathon_recode_way` json DEFAULT NULL COMMENT 'JSON',
  `marathon_record_end` point DEFAULT NULL,
  `marathon_record_dist` int DEFAULT '0',
  `marathon_record_time` int DEFAULT '0',
  `marathon_recode_image` varchar(100) DEFAULT NULL,
  `marathon_recode_pace` json DEFAULT NULL COMMENT 'JSON',
  `marathon_record_mean_pace` int DEFAULT '0',
  `marathon_record_speed` json DEFAULT NULL COMMENT 'JSON',
  `marathon_record_mean_speed` int DEFAULT '0',
  `marathon_record_heartbeat` json DEFAULT NULL COMMENT 'JSON',
  `marathon_record_mean_heartbeat` tinyint DEFAULT '0',
  `marathon_record_is_win` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`marathon_record_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 테이블 데이터 wadada.marathon_record:~80 rows (대략적) 내보내기
-- 테이블 wadada.member 구조 내보내기
CREATE TABLE IF NOT EXISTS `member` (
  `member_seq` int NOT NULL AUTO_INCREMENT,
  `member_nickname` varchar(20) NOT NULL DEFAULT 'ssafy',
  `member_birthday` datetime NOT NULL,
  `member_gender` varchar(1) NOT NULL,
  `member_main_email` varchar(255) NOT NULL,
  `member_profile_image` varchar(255) NOT NULL DEFAULT 'default_image',
  `member_exp` smallint NOT NULL DEFAULT '0',
  `member_total_dist` int NOT NULL DEFAULT '0',
  `member_total_time` int NOT NULL DEFAULT '0',
  `member_level` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `member_id` varchar(25) NOT NULL,
  `member_password` varchar(100) NOT NULL,
  PRIMARY KEY (`member_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 테이블 데이터 wadada.member:~6 rows (대략적) 내보내기

-- 테이블 wadada.member_email 구조 내보내기
CREATE TABLE IF NOT EXISTS `member_email` (
  `member_email` varchar(40) NOT NULL,
  `member_seq` int NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`member_email`,`member_seq`),
  KEY `FK_member_TO_member_email_1` (`member_seq`),
  CONSTRAINT `FK_member_TO_member_email_1` FOREIGN KEY (`member_seq`) REFERENCES `member` (`member_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 테이블 데이터 wadada.member_email:~0 rows (대략적) 내보내기

-- 테이블 wadada.member_role 구조 내보내기
CREATE TABLE IF NOT EXISTS `member_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `member_id` bigint NOT NULL,
  `roles` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 테이블 데이터 wadada.member_role:~12 rows (대략적) 내보내기

-- 테이블 wadada.multi_record 구조 내보내기
CREATE TABLE IF NOT EXISTS `multi_record` (
  `multi_record_seq` int NOT NULL AUTO_INCREMENT,
  `room_seq` int NOT NULL,
  `member_seq` int NOT NULL,
  `multi_record_start` point NOT NULL,
  `multi_record_end` point DEFAULT NULL,
  `multi_record_time` int DEFAULT '0',
  `multi_record_dist` int DEFAULT '0',
  `multi_record_image` varchar(100) DEFAULT NULL,
  `multi_record_rank` tinyint DEFAULT '1' COMMENT ' 6',
  `multi_record_way` json DEFAULT NULL COMMENT 'JSON',
  `multi_record_pace` json DEFAULT NULL COMMENT 'JSON',
  `multi_record_speed` json DEFAULT NULL COMMENT 'JSON',
  `multi_record_heartbeat` json DEFAULT NULL COMMENT 'JSON',
  `multi_record_people` tinyint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `multi_record_mean_pace` int DEFAULT '0',
  `multi_record_mean_speed` int DEFAULT '0',
  `multi_record_mean_heartbeat` tinyint DEFAULT '0',
  PRIMARY KEY (`multi_record_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 테이블 데이터 wadada.multi_record:~218 rows (대략적) 내보내기


-- 테이블 wadada.reward 구조 내보내기
CREATE TABLE IF NOT EXISTS `reward` (
  `member_seq` int NOT NULL,
  `reward_seq` smallint NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`member_seq`),
  CONSTRAINT `FK_member_TO_reward_1` FOREIGN KEY (`member_seq`) REFERENCES `member` (`member_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 테이블 데이터 wadada.reward:~0 rows (대략적) 내보내기

-- 테이블 wadada.room 구조 내보내기
CREATE TABLE IF NOT EXISTS `room` (
  `room_seq` int NOT NULL AUTO_INCREMENT,
  `room_title` varchar(30) NOT NULL,
  `room_people` tinyint NOT NULL DEFAULT '1',
  `room_mode` tinyint NOT NULL,
  `room_tag` varchar(100) DEFAULT NULL,
  `room_secret` int DEFAULT NULL,
  `room_dist` int DEFAULT '0',
  `room_time` int DEFAULT '0',
  `room_maker` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `room_target_point` point DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`room_seq`),
  KEY `FK_room_maker_TO_member` (`room_maker`),
  CONSTRAINT `FK_room_maker_TO_member` FOREIGN KEY (`room_maker`) REFERENCES `member` (`member_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 테이블 데이터 wadada.room:~36 rows (대략적) 내보내기

-- 테이블 wadada.single_record 구조 내보내기
CREATE TABLE IF NOT EXISTS `single_record` (
  `single_record_seq` int NOT NULL AUTO_INCREMENT,
  `member_seq` int NOT NULL,
  `single_record_start` point NOT NULL,
  `single_record_end` point DEFAULT NULL,
  `single_record_time` int DEFAULT NULL,
  `single_record_dist` int DEFAULT NULL,
  `single_record_image` varchar(255) DEFAULT NULL COMMENT '   ',
  `single_record_way` json DEFAULT NULL COMMENT 'JSON',
  `single_record_pace` json DEFAULT NULL COMMENT 'JSON',
  `single_record_mean_pace` int DEFAULT NULL,
  `single_record_heartbeat` json DEFAULT NULL COMMENT 'JSON',
  `single_record_mean_heartbeat` tinyint DEFAULT NULL,
  `single_record_speed` json DEFAULT NULL COMMENT 'JSON',
  `single_record_mean_speed` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `single_record_mode` int NOT NULL,
  PRIMARY KEY (`single_record_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
