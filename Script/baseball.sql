select *
from people;
-- fact table

-- 1. What range of years for baseball games played does the provided database cover? 
select min(year), max(year) 
from homegames;
--games range from 1871 to 2016

-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
select namefirst, namelast, height, g_all, teams.name
from people
join appearances
using(playerid)
join teams
using(teamid)
where height = (select min(height) from people);
--Eddie Gaedel was only 43 inches tall and played 1 games for the St. Louis Browns

-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
--schoolid = vandy
select namefirst, namelast, sum(salary) as total_salary
from people
join salaries 
using(playerid)
join collegeplaying
using(playerid)
where schoolid like 'vandy'
group by namefirst, namelast
order by total_salary desc;
-- David price has earned the most money at $245,553,888

-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
select sum(po) as putouts,
case when pos = 'OF' then 'Outfield'
when pos IN ('SS','1B','2B','3B') then 'Infield'
else 'Battery' end as position
from fielding
where yearid = '2016'
group by position;

/* 41424	"Battery"
58934	"Infield"
29560	"Outfield" */

-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
select (yearid)/10*10 as Decade, round(sum(cast(so as numeric))/sum(cast(g as numeric)),2) as strikeouts_game, (round(sum(cast(hr as numeric))/sum(cast(g as numeric)),2)) as hr_game
from teams
where yearid >=1920
group by decade
order by decade;
-- both the strikeouts per game and the homeruns per games have increased significantly over the last 100 years

-- 6.Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.
select namefirst, namelast, 100 * (sb/(sb + cs)::numeric) as stolen_percent,sb,cs
from people
inner join batting
using(playerid)
where sb + cs >= 20 and yearid = '2016'
order by stolen_percent desc;
--Chris Owings had the highest sb percent at 91.3%

-- 7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?


-- 8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.
select team,park_name, (attendance/games) as avg_attendance
from homegames
inner join parks
using(park)
where year = '2016' 
and games >= 10
order by avg_attendance desc
limit 5;
/* "LAN"	"Dodger Stadium"	45719
"SLN"	"Busch Stadium III"	42524
"TOR"	"Rogers Centre"	41877
"SFN"	"AT&T Park"	41546
"CHN"	"Wrigley Field"	39906 */



select team,park_name, (attendance/games) as avg_attendance
from homegames
inner join parks
using(park)
where year = '2016' 
and games >= 10
order by avg_attendance 
limit 5;
/* "TBA"	"Tropicana Field"	15878
"OAK"	"Oakland-Alameda County Coliseum"	18784
"CLE"	"Progressive Field"	19650
"MIA"	"Marlins Park"	21405
"CHA"	"U.S. Cellular Field"	21559 */