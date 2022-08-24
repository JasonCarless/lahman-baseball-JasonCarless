select *
from people;
-- fact table

select min(year), max(year) 
from homegames;
--games range from 1871 to 2016

select namefirst, namelast, height, g_all, teams.name
from people
join appearances
using(playerid)
join teams
using(teamid)
where height = (select min(height) from people);
--Eddie Gaedel was only 43 inches tall and played 1 games for the St. Louis Browns

