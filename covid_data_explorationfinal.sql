Select location, date, total_cases, new_cases, total_deaths, population
From portfolio_project.coviddeaths1
order by 1,2;

-- Looking at total cases vs total deaths
-- shows likelihood of dying your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS CFR
From portfolio_project.coviddeaths1
where location = 'india'
order by 1,2 desc;

-- Looking at total cases vs population
-- which country has the highest postivity rate with respect to population 

Select location, date, total_cases, population, (total_cases/population)*100 AS cases_per_population
From portfolio_project.coviddeaths1
order by 5 desc;

-- Highest death count per country

Select location, continent,Max(cast(total_deaths AS unsigned integer)) AS totaldeathcount
From portfolio_project.coviddeaths1
where location != 'europe'
Group By location,continent
Order By totaldeathcount desc;

-- Break things down by Continent

Select continent, Max(cast(total_deaths AS unsigned integer)) AS totaldeathcount
From portfolio_project.coviddeaths1
where continent is not null
Group By continent
Order By totaldeathcount desc;

-- Global numbers -- highest new cases reported worldwide in a day
-- highest new deaths reported worldwide in a day

Select date, sum(new_cases), sum(new_deaths), (sum(new_deaths)/sum(new_cases))*100 AS deathpercentage
from portfolio_project.coviddeaths1
where continent is not null
group by date
order by 3 desc;

-- JOIN two tables 


SELECT fatality.continent, fatality.location, fatality.date, fatality.population, immunity.new_vaccinations
from portfolio_project.coviddeaths1 AS fatality
join portfolio_project.covidvaccination AS immunity
on fatality.location = immune]ity.location
and fatality.date = immunity.date
order by 3 desc;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select fatality.continent, fatality.location, fatality.date, fatality.population, immunity.new_vaccinations
, SUM(immunity.new_vaccinations) OVER (Partition by fatality.Location Order by fatality.location, fatality.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From portfolio_project.coviddeaths1 AS fatality
Join portfolio_project.covidvaccination AS immunity 
	On fatality.location = immunity.location
	and fatality.date = immunity.date
where fatality.continent is not null 
order by 2,3;

-- Rolling Numbers for vaccination in India
-- Using CTE- common table expression to perform calculation on partition by in order to get the % of peoeple vaccinated based on population
-- PARTITION BY is used for rolling count



With popvsvac ( continent,location, date, population, new_vaccinations, rolling_count)
AS
(
SELECT fatality.continent, fatality.location, fatality.date, fatality.population, immunity.new_vaccinations,
sum(immunity.new_vaccinations) OVER (Partition By fatality.location Order By fatality.location, fatality.date) AS rolling_count
from portfolio_project.coviddeaths1 AS fatality
join portfolio_project.covidvaccination AS immunity
on fatality.location = immunity.location
and fatality.date = immunity.date
where fatality.continent is not null
-- and fatality.location = 'India'
-- order by 2,3
)
Select *, (rolling_count/population)*100 as vaccination_rate
From popvsvac
order by vaccination_rate desc;



-- Create View for Visualizations

Create View PercentPopulationVaccinated AS
Select fatality.continent, fatality.location, fatality.date, fatality.population, immunity.new_vaccinations
, SUM(immunity.new_vaccinations)OVER (Partition by fatality.Location Order by fatality.location, fatality.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From portfolio_project.coviddeaths1 dea
Join portfolio_project.covidvaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
    where dea.continent is not null;
-- order by 2,3 percentpopulationvaccinated
    
-- Comorbidity rate 
-- diabetes prevalence

Create view  ComorbidityRate2 AS
Select fatality.continent, fatality.location, fatality.population, immunity.diabetes_prevalence

From portfolio_project.coviddeaths1 AS fatality
JOIN portfolio_project.covidvaccination AS immunity
     ON fatality.location = immunity.location
     AND fatality.date = immunity.date
     WHERE fatality.continent is not null
     Order By immunity.diabetes_prevalence Desc; -- find a way to improve this view. Group the location and make sure the table shows only one value per location







