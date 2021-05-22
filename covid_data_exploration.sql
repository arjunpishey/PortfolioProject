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


SELECT fatal.continent, fatal.location, fatal.date, fatal.population, immune.new_vaccinations
from portfolio_project.coviddeaths1 AS fatal
join portfolio_project.covidvaccination AS immune
on fatal.location = immune.location
and fatal.date = immune.date
order by 3 desc;


-- Rolling Numbers for vaccination in India

With popvsvac ( continent,location, date, population, new_vaccinations, rolling_count)
AS
(
SELECT fatal.continent, fatal.location, fatal.date, fatal.population, immune.new_vaccinations,
sum(immune.new_vaccinations) OVER (Partition By fatal.location Order By fatal.location, fatal.date) AS rolling_count
from portfolio_project.coviddeaths1 AS fatal
join portfolio_project.covidvaccination AS immune
on fatal.location = immune.location
and fatal.date = immune.date
where fatal.continent is not null
-- and fatal.location = 'India'
-- order by 2,3
)
Select *, (rolling_count/population)*100 as vaccination_rate
From popvsvac
order by vaccination_rate desc;



-- Create View for Visualizations

Create View PercentPopulationVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations)OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From portfolio_project.coviddeaths1 dea
Join portfolio_project.covidvaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
    where dea.continent is not null 
    
-- order by 2,3 percentpopulationvaccinated








