/* 
 table structure:
 eteam(id PK, teamname, coach)
 game(id PK, mdate, stadium, team1 FK, team2 FK)
 goal(matchid PK FK, teamid FK, player, gtime PK) 
 
 game
 id	mdate	stadium	team1	team2
 1001	8 June 2012	National Stadium, Warsaw	POL	GRE
 1002	8 June 2012	Stadion Miejski (Wroclaw)	RUS	CZE
 1003	12 June 2012	Stadion Miejski (Wroclaw)	GRE	CZE
 1004	12 June 2012	National Stadium, Warsaw	POL	RUS
 ...
 
 goal
 matchid	teamid	player	gtime
 1001	POL	Robert Lewandowski	17
 1001	GRE	Dimitris Salpingidis	51
 1002	RUS	Alan Dzagoev	15
 1002	RUS	Roman Pavlyuchenko	82
 ...
 
 eteam
 id	teamname	coach
 POL	Poland	Franciszek Smuda
 RUS	Russia	Dick Advocaat
 CZE	Czech Republic	Michal Bilek
 GRE	Greece	Fernando Santos
 ...
 
 */
-- 1.
-- show the matchid and player name for all goals scored by Germany.
SELECT matchid,
    player
FROM goal
WHERE teamid = 'GER';

-- 2
-- Show id, stadium, team1, team2 for just game 1012
SELECT id,
    stadium,
    team1,
    team2
FROM game
WHERE id = 1012;

-- 3
-- show the player, teamid, stadium and mdate for every German goal.
SELECT player,
    teamid,
    stadium,
    mdate
FROM game
    JOIN goal ON (id = matchid)
WHERE teamid = 'GER';

-- 4
-- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1,
    team2,
    player
FROM goal
    JOIN game ON (matchid = id)
WHERE player LIKE 'Mario%';

-- 5
-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player,
    teamid,
    coach,
    gtime
FROM goal
    JOIN eteam ON (teamid = id)
WHERE gtime <= 10;

--  6
--  List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate,
    teamname
FROM game
    JOIN eteam ON (team1 = eteam.id)
WHERE coach = 'Fernando Santos';

-- 7
-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player
FROM game
    JOIN goal ON (id = matchid)
WHERE stadium = 'National Stadium, Warsaw';

-- 8
-- Show the name of all players who scored a goal against Germany.
SELECT DISTINCT player
FROM game
    JOIN goal ON matchid = id
WHERE (
        team1 = 'GER'
        OR team2 = 'GER'
    )
    AND teamid != 'GER';

-- 9
-- Show teamname and the total number of goals scored.
SELECT teamname,
    COUNT(player)
FROM eteam
    JOIN goal ON id = teamid
GROUP BY teamname;

-- 10
-- Show the stadium and the number of goals scored in each stadium
SELECT stadium,
    COUNT(gtime)
FROM game
    JOIN goal ON (id = matchid)
GROUP BY stadium;

-- 11
-- For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid,
    mdate,
    COUNT(gtime)
FROM game
    JOIN goal ON matchid = id
WHERE (
        team1 = 'POL'
        OR team2 = 'POL'
    )
GROUP BY matchid,
    mdate;

-- 12
-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid,
    mdate,
    COUNT(gtime)
FROM game
    JOIN goal ON (id = matchid)
WHERE teamid = 'GER'
GROUP BY matchid,
    mdate;

-- 13
-- If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.
SELECT mdate,
    team1,
    sum(
        CASE
            WHEN teamid = team1 THEN 1
            ELSE 0
        END
    ) score1,
    team2,
    sum(
        CASE
            WHEN teamid = team2 THEN 1
            ELSE 0
        END
    ) score2
FROM game
    LEFT JOIN goal ON matchid = id
GROUP BY mdate,
    team1,
    team2
ORDER BY mdate,
    matchid,
    team1,
    team2;

/*
The following query may seem correct, 
SELECT mdate, team1, SUM(subscore1) AS score1, team2, SUM(subscore2) AS score2
FROM (SELECT mdate,matchid, 
  team1,
  CASE WHEN teamid=team1 THEN 1 ELSE 0 END subscore1,
  team2,
  CASE WHEN teamid=team2 THEN 1 ELSE 0 END subscore2
  FROM game JOIN goal ON matchid = id) matchgoal
GROUP BY mdate, team1, team2
ORDER BY mdate, matchid, team1, team2

but it ignores cases that both team got 0 goal.
mdate	team1	score1	team2	score2
24 June 2012	ENG	0	ITA	0
27 June 2012	POR	0	ESP	0

*/

-- Quiz
-- DCAAB CB