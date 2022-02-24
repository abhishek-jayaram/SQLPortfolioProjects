select *
from PortfolioProject..[Covid Deaths]
where continent is not null
order by 3,4

--select *
--from PortfolioProject..[Covid Vaccinations]
--order by 3,4

select location,date, total_cases,new_cases,total_deaths,population
from PortfolioProject..[Covid Deaths]
order by 1,2

select location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..[Covid Deaths]
where location like '%india%'
order by 1,2

select location,date, total_cases,population, (total_cases/population)*100 as DeathPercentage
from PortfolioProject..[Covid Deaths]
where location like '%india%'
order by 1,2


select location,population, MAX(total_cases) as Highestinfectioncount, MAX((total_cases/population))*100 as PercentageofEffets
from PortfolioProject..[Covid Deaths]
--where location like '%india%'
group by location,population
order by PercentageofEffets desc

select location, max(total_cases) as TotalDeathCount
from PortfolioProject..[Covid Deaths]
where continent is not null
group by location
order by totaldeathcount Desc


select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 asDeathPercentage
From PortfolioProject..[Covid Deaths]
where continent is not null
group by date
order by 1,2

select [Covid Deaths].continent, [Covid Deaths].location,[Covid Deaths].date,[Covid Deaths].population,[Covid Vaccinations].new_vaccinations
from PortfolioProject..[Covid Vaccinations]
join PortfolioProject..[Covid Deaths]
on [Covid Deaths].location = [Covid Vaccinations].location
and [Covid Deaths].date = [Covid Vaccinations].date
where [Covid Deaths].continent is not null
order by 2,3


with popvsVac (continent,location,date,population,New_vaccinations,RollingPeopleVaccinated) as
(
select [Covid Deaths].continent, [Covid Deaths].location,[Covid Deaths].date,[Covid Deaths].population,[Covid Vaccinations].new_vaccinations
,sum(convert(int,[Covid Vaccinations].new_vaccinations)) over (Partition by [Covid Deaths].location order by [Covid Deaths].location,
[Covid Deaths].date) as RollingPeopleVaccinated
from PortfolioProject..[Covid Vaccinations]
join PortfolioProject..[Covid Deaths]
on [Covid Deaths].location = [Covid Vaccinations].location
and [Covid Deaths].date = [Covid Vaccinations].date
where [Covid Deaths].continent is not null
--order by 2,3
)
select*, (RollingPeopleVaccinated/population)*100
from PopvsVac


drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

select [Covid Deaths].continent, [Covid Deaths].location,[Covid Deaths].date,[Covid Deaths].population,[Covid Vaccinations].new_vaccinations
,sum(convert(int,[Covid Vaccinations].new_vaccinations)) over (Partition by [Covid Deaths].location order by [Covid Deaths].location,
[Covid Deaths].date) as RollingPeopleVaccinated
from PortfolioProject..[Covid Vaccinations]
join PortfolioProject..[Covid Deaths]
on [Covid Deaths].location = [Covid Vaccinations].location
and [Covid Deaths].date = [Covid Vaccinations].date
--where [Covid Deaths].continent is not null
--order by 2,3
select*, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


Create View PercentPopulationVaccinated as
select [Covid Deaths].continent, [Covid Deaths].location,[Covid Deaths].date,[Covid Deaths].population,[Covid Vaccinations].new_vaccinations
,sum(convert(int,[Covid Vaccinations].new_vaccinations)) over (Partition by [Covid Deaths].location order by [Covid Deaths].location,
[Covid Deaths].date) as RollingPeopleVaccinated
from PortfolioProject..[Covid Vaccinations]
join PortfolioProject..[Covid Deaths]
on [Covid Deaths].location = [Covid Vaccinations].location
and [Covid Deaths].date = [Covid Vaccinations].date
where [Covid Deaths].continent is not null
--order by 2,3


select*
from PercentPopulationVaccinated