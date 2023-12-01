Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

-- Select Data to use

Select  Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2


-- Looking at Total Cases VS Total Deaths
-- Percentage of passing away if you contracted covid in your country
Select Location, date, total_cases, total_deaths, CONVERT(DECIMAL(18,2),(CONVERT(DECIMAL(18,2),total_deaths) / NULLIF(CONVERT(DECIMAL(18,2),total_cases), 0)) * 100) AS DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%' and continent is not null
order by 1,2


-- Looking at Total Cases VS Total Population
-- What percent of population got covid
Select Location, date, Population, total_cases,  (total_cases/Population)*100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%' and continent is not null
order by 1,2


--Countires with highest population rate compared to population
Select Location, Population, MAX(total_cases) as HighestInfectedCount,  MAX((total_cases/Population))*100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%' and continent is not null
Group by Location, Population
order by PercentPopulationInfected DESC


-- Countries with highest death count per population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%' and continent is not null
Where continent is not null
Group by Location
order by TotalDeathCount DESC

-- Countries with highest death count by continent
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%' and continent is not null
Where continent is not null
Group by continent
order by TotalDeathCount DESC



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 