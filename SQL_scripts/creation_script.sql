DROP DATABASE IF EXISTS tourn;
CREATE DATABASE IF NOT EXISTS tourn;

USE tourn;

SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE `users` (
	`user_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `nick` VARCHAR(45) NOT NULL,
    `user_type_id` INT NOT NULL,
    CONSTRAINT `PK_users` PRIMARY KEY (`user_id`)
);

CREATE TABLE `user_types` (
	`user_type_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `user_type` VARCHAR(45),
	CONSTRAINT `PK_user_types` PRIMARY KEY (`user_type_id`)
);
    
CREATE TABLE `tournaments` (
	`tournament_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `tournament_activity` VARCHAR(45) NOT NULL,
    `tournament_type_id` INT NOT NULL,
    `tournament_admin_id` INT NOT NULL,
    `completed_status` BOOLEAN NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE,
	`standings_id` INT NOT NULL, -- standings can be used to get winner
    CONSTRAINT `PK_tournaments` PRIMARY KEY (`tournament_id`)
);

CREATE TABLE `tournament_types` (
	`tournament_type_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `tournament_type` VARCHAR(45),
    CONSTRAINT `PK_tournament_types` PRIMARY KEY (`tournament_type_id`)
);

CREATE TABLE `standings` (
	`standings_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `tournament_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `points` INT NOT NULL,
    CONSTRAINT `PK_standings` PRIMARY KEY (`standings_id`)
);

CREATE TABLE `matches` (
	`match_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `match_date` DATE NOT NULL,
    `tournament_id` INT NOT NULL,
    `competitor1_id` INT NOT NULL,
    `competitor2_id` INT NOT NULL,
    `state` VARCHAR(20),
    `match_winner_id` INT,
    CONSTRAINT `PK_matches` PRIMARY KEY (`match_id`)
);

ALTER TABLE `users`
ADD FOREIGN KEY (`user_type_id`) REFERENCES `user_types` (`user_type_id`);

ALTER TABLE `tournaments`
ADD FOREIGN KEY (`tournament_type_id`) REFERENCES `tournament_types` (`tournament_type_id`);

ALTER TABLE `tournaments`
ADD FOREIGN KEY (`tournament_admin_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `standings`
ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `standings`
ADD FOREIGN KEY (`tournament_id`) REFERENCES `tournaments` (`tournament_id`);

ALTER TABLE `matches`
ADD FOREIGN KEY (`tournament_id`) REFERENCES `tournaments` (`tournament_id`);
ALTER TABLE `matches`
ADD FOREIGN KEY (`competitor1_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `matches`
ADD FOREIGN KEY (`competitor2_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `matches`
ADD FOREIGN KEY (`match_winner_id`) REFERENCES `users` (`user_id`);

TRUNCATE TABLE `users`;
INSERT INTO `users` (`nick`, `user_type_id`)
VALUES ('Saul', 1);
INSERT INTO `users` (`nick`, `user_type_id`)
VALUES ('Tommy', 2);
INSERT INTO `users` (`nick`, `user_type_id`)
VALUES ('Paul', 2);


TRUNCATE TABLE `user_types`;
INSERT INTO `user_types` (`user_type`)
VALUES ('tournament admin');
INSERT INTO `user_types` (`user_type`)
VALUES ('tournament member');

TRUNCATE TABLE `tournaments`;
INSERT INTO `tournaments` (`tournament_activity`, `tournament_type_id`, `tournament_admin_id`, `completed_status`, `start_date`, `end_date`, `standings_id`)
VALUES ('chess', 1, 1, 1, '2021-05-15', '2021-05-20', 1);

TRUNCATE TABLE `matches`;
INSERT INTO `matches` (`tournament_id`, `match_date`, `competitor1_id`, `competitor2_id`, `state`, `match_winner_id`)
VALUES (1, '2021-05-15', 1, 3, 'complete', 3);
INSERT INTO `matches` (`tournament_id`, `match_date`, `competitor1_id`, `competitor2_id`, `state`, `match_winner_id`)
VALUES (1, '2021-05-18', 1, 2, 'complete', null);
INSERT INTO `matches` (`tournament_id`, `match_date`, `competitor1_id`, `competitor2_id`, `state`, `match_winner_id`)
VALUES (1, '2021-05-20', 3, 2, 'complete', 3);

TRUNCATE TABLE `standings`;
INSERT INTO `standings` (`tournament_id`, `user_id`, `points`)
VALUES (1, 1, 1);
INSERT INTO `standings` (`tournament_id`, `user_id`, `points`)
VALUES (1, 2, 1);
INSERT INTO `standings` (`tournament_id`, `user_id`, `points`)
VALUES (1, 3, 6);

-- STORED PROCEDURES

-- stored procedure to view standings taking tournament id as input
DROP PROCEDURE IF EXISTS getStandings;
DELIMITER //
CREATE PROCEDURE getStandings(
	IN tournamentIdIn INT
)
BEGIN
	SELECT users.user_id, users.nick, standings.points
	FROM standings
	JOIN tournaments ON
	tournaments.tournament_id = standings.tournament_id
	JOIN users ON
	users.user_id = standings.user_id
    WHERE tournaments.tournament_id = tournamentIdIn
    ORDER BY standings.points DESC;
END //
DELIMITER ;

-- Stored procedure to view matches taking tournament id as input
DROP PROCEDURE IF EXISTS getMatches;
DELIMITER //
CREATE PROCEDURE getMatches (
	IN tournamentIdIn INT
)
BEGIN
	SELECT matches.match_id, CONCAT(DAY(matches.match_date),'th ', MONTHNAME(matches.match_date), ' ', YEAR(matches.match_date)), 
    users.nick as `player one`, u2.nick as `player two`, COALESCE(u3.nick, 'draw') as `winner`, matches.state
	FROM matches
	JOIN tournaments ON
	tournaments.tournament_id = matches.tournament_id
	JOIN users ON 
	users.user_id = matches.competitor1_id
	JOIN users u2 ON 
	u2.user_id = matches.competitor2_id
	LEFT OUTER JOIN users u3 ON 
	u3.user_id = matches.match_winner_id
    WHERE matches.tournament_id = tournamentIdIn
    ORDER BY matches.match_date;
END //
DELIMITER ;