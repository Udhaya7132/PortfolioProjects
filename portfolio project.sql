Select * From PortfolioProject..CovidDeaths$
where continent is not null

-- select * from PortfolioProject..CovidVaccinations$

-- The data we're going to use
select location, date ,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths$

-- Looking at Total Cases vs Total Deaths

select location, date ,total_cases,new_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
order by 1,2

select location, date ,total_cases,new_cases,total_deaths, (total_deaths/total_cases)*100
from PortfolioProject..CovidDeaths$
where location like 'india'

--Looking at total cases vs Population
select location, date ,total_cases, population, (total_cases/population)*100 as TotalCases_Population
from PortfolioProject..CovidDeaths$
where location like 'india'
order by 1,2

-- Looking at Countries with HIghest inflation Rate compared to Population
select location , Population, max(total_cases) as Max_Infection_Count, Max(total_cases/population)*100 as Total_Population_infected
from PortfolioProject..CovidDeaths$
group by location,population
order by Total_Population_infected desc

-- Showing Countries with the highest death count 
select location, max(total_cases) as Total_cases , max(total_deaths) as Total_death_count
from PortfolioProject..CovidDeaths$
group by location
order by Total_death_count desc

select location , MAX(CAST(Total_deaths as int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc

-- Let's Break things down by continent

select location,MAX(CAST(Total_deaths as int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths$
where continent is  null
group by location
order by TotalDeathCount desc

-- Showing continent with highest death count

select * from PortfolioProject..CovidDeaths$

Select location, total_cases, total_deaths ,(total_deaths/total_cases)*100 as Death_percentage
from PortfolioProject..CovidDeaths$
where location like 'india'
and continent is not null
order by Death_percentage desc

-- Global Numbers

select date, sum(new_cases)  as Total_cases from PortfolioProject..CovidDeaths$
where continent is not null
group by date

select date, sum(new_cases), sum(cast(new_deaths as int)), sum(cast(new_deaths as int))/SUM(new_deaths)*100
from PortfolioProject..CovidDeaths$
where continent is not null
--group by date
order by 1,2

select date, sum(new_cases), sum(cast(new_deaths as int))
from
PortfolioProject..CovidDeaths$
group by date

Select SUM(new_cases), SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases) as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2
 

 Select * from
PortfolioProject..CovidDeaths$

 -- Total Pop vs Vaccination

select * from 
PortfolioProject..CovidDeaths$ as d
join PortfolioProject..CovidVaccinations$ as v on
d.location = v.location
and d.date =v.date


select d.location,d.continent, sum(d.population)
from PortfolioProject..CovidDeaths$ as d
join PortfolioProject..CovidVaccinations$ as v on
d.location = v.location
and d.date =v.date
group by d.location,d.continent

select v.continent ,v.total_vaccinations, d.population , (v.total_vaccinations/d.population)*100 as Vaccination_Percentage
from PortfolioProject..CovidVaccinations$ as v
join PortfolioProject..CovidDeaths$ as d on
d.location = v.location
group by v.continent,v.total_vaccinations,d.population
order by Vaccination_Percentage asc


SELECT v.continent,v.total_vaccinations,d.population,(v.total_vaccinations / d.population) * 100 AS Vaccination_Percentage,
ROW_NUMBER() OVER (PARTITION BY v.continent ORDER BY (v.total_vaccinations / d.population) desc) AS row_num
FROM PortfolioProject..CovidVaccinations$ AS v
JOIN
    PortfolioProject..CovidDeaths$ AS d ON
    d.location = v.location

select d.continent, d.location,d.population,v.new_vaccinations 
from PortfolioProject..CovidVaccinations$ AS v
JOIN PortfolioProject..CovidDeaths$ AS d ON
    d.location = v.location
where d.continent is not null
order by 2,3
	

select d.continent, d.location,d.population,v.new_vaccinations , sum(convert(int ,v.new_vaccinations)) over (partition by d.location)
from PortfolioProject..CovidVaccinations$ AS v
JOIN PortfolioProject..CovidDeaths$ AS d ON
    d.location = v.location
where d.continent is not null
order by 2,3
	

select d.continent , d.location,d.date, d.population , v.new_vaccinations, sum(convert(int ,v.new_vaccinations)) 
over (partition by d.location order by d.location, d.date)
from PortfolioProject..CovidDeaths$ AS d 
join PortfolioProject..CovidVaccinations$ AS v ON d.location = v.location
where d.continent is not null
order by 2,3

Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ as d
Join PortfolioProject..CovidVaccinations$ as v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 
order by 2,3

-- use CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *
From PopvsVac


-- Create temp table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

select * ,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

create view PercentPopVaccinated as 
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
SUM(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location,d.date) as RollingPopVaccinated
from PortfolioProject..CovidDeaths$ as d
join PortfolioProject..CovidDeaths$ as v
On d.location = v.location
	and d.date = v.date
where d.continent is not null 













