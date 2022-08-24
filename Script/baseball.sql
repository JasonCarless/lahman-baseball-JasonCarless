select *
from people;
-- fact table

--1. What range of years for baseball games played does the provided database cover? 
select min(year), max(year) 
from homegames;
--games range from 1871 to 2016

--2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
select namefirst, namelast, height, g_all, teams.name
from people
join appearances
using(playerid)
join teams
using(teamid)
where height = (select min(height) from people);
--Eddie Gaedel was only 43 inches tall and played 1 games for the St. Louis Browns

--3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
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

--4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
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

--5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
select (yearid)/10*10 as Decade, (round(sum(cast(so as numeric))/sum(cast(g as numeric)),2)) as strikeouts_game, (round(sum(cast(hr as numeric))/sum(cast(g as numeric)),2)) as hr_game
from teams
where yearid >=1920
group by decade
order by decade;
-- both the strikeouts per game and the homeruns per games have increased significantly over the last 100 years




