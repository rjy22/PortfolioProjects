SELECT *
FROM AA_PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

--SELECT *
--FROM AA_PortfolioProject..CovidVaccinations
--ORDER BY 3,4;

-- SELECT data to be used

SELECT continent, location, date, total_cases, new_cases, total_deaths, population
FROM AA_PortfolioProject..CovidDeaths
ORDER BY 1,2;

-- Compare Total Deaths vs Total Cases
-- Calculate likelihood of dying after contracting COVID-19 in each country

SELECT continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM AA_PortfolioProject..CovidDeaths
--WHERE location LIKE '%states%'
ORDER BY 1,2;

-- Compare Total Cases vs Population
-- Calculate percentage of populations infected with COVID-19

SELECT continent, location, date, population, total_cases, (total_cases/population)*100 AS CasePercentage
FROM AA_PortfolioProject..CovidDeaths
--WHERE location LIKE '%states%'
ORDER BY 1,2;

-- Display countries with highest infection rates compared to population

SELECT continent, location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS InfectionPercentage
FROM AA_PortfolioProject..CovidDeaths
--WHERE location LIKE '%states%'
GROUP BY continent, location, population
ORDER BY InfectionPercentage DESC;

-- Display countries with highest death count per population

SELECT continent, location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM AA_PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, location
ORDER BY TotalDeathCount DESC;

-- Selecting for continent

SELECT continent, location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM AA_PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY continent, location
ORDER BY TotalDeathCount DESC;

-- Selecting for global count

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS GlobalDeathPercentage
FROM AA_PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2;



-- Select for Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
	AS RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100
FROM AA_PortfolioProject..CovidDeaths dea
JOIN AA_PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- Usage of CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
  dea.date)	AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM AA_PortfolioProject..CovidDeaths dea
JOIN AA_PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac
ORDER BY location, date


-- Usage of temp table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
  dea.date)	AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM AA_PortfolioProject..CovidDeaths dea
JOIN AA_PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated
ORDER BY location, date


-- Creating View for data storage to use in future visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
  dea.date)	AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM AA_PortfolioProject..CovidDeaths dea
JOIN AA_PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated
