-- COVID-19 Visualization Queries for Tableau


-- 1.

Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
(sum(new_deaths)/sum(new_cases))*100 as Death_percentage
from covid_death.covid_deaths 
where continent is not null 
order by 1, 2;


-- 2.

Select Continent, sum(new_deaths) as Total_deaths_count
from covid_death.covid_deaths 
where continent in ('Asia', 'Europe', 'North America', 'Africa', 'Oceania')
-- where continent not in ('', 'South America')
group by continent
order by total_deaths_count desc;


-- 3. 

Select location, population, max(total_cases) as highest_infection_count,
(max(total_cases)/population)*100 as Percent_population_infected 
from covid_death.covid_deaths 
group by location, population
order by Percent_population_infected desc;


-- 4.

Select location, population, date, max(total_cases) as highest_infection_count,
(max(total_cases)/population)*100 as Percent_population_infected 
from covid_death.covid_deaths 
group by location, population ,date 
order by Percent_population_infected desc;