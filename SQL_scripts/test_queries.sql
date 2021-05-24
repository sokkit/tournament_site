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
	SELECT tournaments.tournament_activity, users.nick, standings.points
	FROM standings
	JOIN tournaments ON
	tournaments.tournament_id = standings.tournament_id
	JOIN users ON
	users.user_id = standings.user_id
    WHERE tournaments.tournament_id = tournamentIdIn;
END //
DELIMITER ;

CALL getStandings(1);

-- view matches
SELECT matches.match_id, matches.match_date, tournaments.tournament_activity, users.nick as `player one`, u2.nick as `player two`, COALESCE(u3.nick, 'draw') as `winner`, matches.state
FROM matches
JOIN tournaments ON
tournaments.tournament_id = matches.tournament_id
JOIN users ON 
users.user_id = matches.competitor1_id
JOIN users u2 ON 
u2.user_id = matches.competitor2_id
LEFT OUTER JOIN users u3 ON 
u3.user_id = matches.match_winner_id;




