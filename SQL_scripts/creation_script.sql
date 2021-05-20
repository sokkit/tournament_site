DROP DATABASE IF EXISTS tourn;
CREATE DATABASE IF NOT EXISTS tourn;

USE tourn;

SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE `users` (
	`user_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `forename` VARCHAR(45) NOT NULL,
    `surname` VARCHAR(45) NOT NULL,
    `user_type_id` INT NOT NULL,
    CONSTRAINT `PK_users` PRIMARY KEY (`user_id`)
);
    
CREATE TABLE `tournaments` (
	`tournament_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `tournament_type_id` INT NOT NULL,
    `tournament_admin_id` INT NOT NULL,
    `completed_status` BOOLEAN NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE,
	`standings_id` INT NOT NULL, -- standings can be used to get winner
    CONSTRAINT `PK_tournaments` PRIMARY KEY (`tournament_id`)
);

CREATE TABLE `standings` (
	`standings_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `tournament_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `points` INT NOT NULL,
    CONSTRAINT `PK_standings` PRIMARY KEY (`standings_id`)
);

CREATE TABLE `matches` (
	`match_id` INT NOT NULL,
    `tournament_id` INT NOT NULL,
    `competitor_id` INT NOT NULL,
    `win_status` BOOLEAN,
    CONSTRAINT `PK_matches` PRIMARY KEY (`match_id`)
);
