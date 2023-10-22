-- COVID-19 Data Exploration 

Select * From covid_death.covid_deaths
where continent is not null
order by 5 , 6;
 
Select * From covid_death.covid_vaccination
where continent is not null
order by 3 ,4;

-- Select Data

Select location, date, total_cases, new_cases, total_deaths, population 
From covid_deaths
where continent is not null
order by 1 ,2;

-- Total cases vs Total Deaths 
-- Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
From covid_deaths
-- where location like '%india%'
order by 1 ,2;


-- total Cases vs Population 
-- Percentage of population infectefed with Covid

Select location, date, total_cases, population, (total_cases/population)*100 as Population_infected_percentage
From covid_deaths
-- where location like '%india%'
order by 1 ,2;


-- Looking at Countries wth Highest Infection Rate compared to population 

Select location, population, max(total_cases) as Highest_infection_count,
max((total_cases/population))*100 as Percent_population_infected
From covid_deaths
where continent is not null
group by location, population
order by Percent_population_infected desc;


-- Countries with highest death count per population

Select location, MAX(total_deaths) as Total_death_count
From covid_deaths
where continent is not null
group by location
order by Total_death_count desc;


-- Contintents with highest death count per population

Select continent, MAX(total_deaths) as Total_death_count
From covid_deaths
where continent is not null
group by continent
order by Total_death_count;


-- Global cases and deaths

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
sum(new_deaths)/sum(new_cases)*100 as Death_percentage
from covid_deaths 
where continent is not null
order by 1, 2;

select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
sum(new_deaths)/sum(new_cases)*100 as Death_percentage
from covid_deaths 
where continent is not null
group by date
order by 1, 2;


-- Vaccinations table 

select * from covid_vaccination
where continent is not null;


-- Joining tables

select * from covid_deaths as d
join covid_vaccination as v
on d.date = v.date and d.location = v.location;


-- Total population vs Vaccination 
-- Population that has recieved at least one Covid Vaccine

select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) 
as Rolling_people_vaccinated
-- (Rolling_people_vaccinated/population)*100 
from covid_deaths as d 
join covid_vaccination as v
on d.date = v.date and d.location = v.location
where d.continent is not null 
order by 2, 3;


-- Using CTE to perform Calculation on Partition By in previous query 

With PopvsVac (Continent, Location, Date, Population, new_vaccination, Rolling_people_vaccinated)
as (
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) 
as Rolling_people_vaccinated
from covid_deaths as d 
join covid_vaccination as v
on d.date = v.date and d.location = v.location
where d.continent is not null
)
select *, (Rolling_people_vaccinated/population)*100
from PopvsVac;


-- Using Temp table to perform calculation on Partition By in previous query

Drop table if exists Percent_population_vaccinated ;
Create Table Percent_population_vaccinated (
Continent varchar(255),
Location varchar(255),
Date date,
Population numeric,
New_vaccinations numeric,
Rolling_people_vaccinated numeric
);

Insert into Percent_population_vaccinated
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) 
as Rolling_people_vaccinated
from covid_deaths as d 
join covid_vaccination as v
on d.date = v.date and d.location = v.location
where d.continent is not null;

select *, (Rolling_people_vaccinated/population)*100
from Percent_population_vaccinated;
