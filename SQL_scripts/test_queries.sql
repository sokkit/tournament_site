-- view user details
SELECT users.user_id, users.nick, user_types.user_type
FROM users
JOIN user_types ON
users.user_type_id = user_types.user_type_id;

-- view standings
SELECT tournaments.tournament_activity, users.nick, standings.points
FROM standings
JOIN tournaments ON
tournaments.tournament_id = standings.tournament_id
JOIN users ON
users.user_id = standings.user_id;

-- stored procedure to view standings taking tournament id as input
DROP PROCEDURE IF EXISTS getStandings;
DELIMITER //
CREATE PROCEDURE getStandings(
	IN tournamentIdIn INT
)
BEGIN
	SELECT users.nick, standings.points
	FROM standings
	JOIN tournaments ON
	tournaments.tournament_id = standings.tournament_id
	JOIN users ON
	users.user_id = standings.user_id
    WHERE tournaments.tournament_id = tournamentIdIn
    ORDER BY standings.points DESC;
END //
DELIMITER ;

CALL getStandings(1);

-- view matches
SELECT matches.match_id, CONCAT(DAY(matches.match_date),'th ', MONTHNAME(matches.match_date), ' ', YEAR(matches.match_date)), tournaments.tournament_activity, users.nick as `player one`, u2.nick as `player two`, COALESCE(u3.nick, 'draw') as `winner`, matches.state
FROM matches
JOIN tournaments ON
tournaments.tournament_id = matches.tournament_id
JOIN users ON 
users.user_id = matches.competitor1_id
JOIN users u2 ON 
u2.user_id = matches.competitor2_id
LEFT OUTER JOIN users u3 ON 
u3.user_id = matches.match_winner_id;

-- Stored procedure to view matches taking tournament id as input
DROP PROCEDURE IF EXISTS getMatches;
DELIMITER //
CREATE PROCEDURE getMatches (
	IN tournamentIdIn INT
)
BEGIN
	SELECT matches.match_id, matches.match_date, users.nick as `player one`, u2.nick as `player two`, COALESCE(u3.nick, 'draw') as `winner`, matches.state
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

CALL getMatches(1);
