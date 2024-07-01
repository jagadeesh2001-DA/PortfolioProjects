SELECT * FROM Portfolio_Project..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT * FROM Portfolio_Project..CovidVaccinations$
ORDER BY 3,4

--DATA WE ARE GOING TO USE

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM Portfolio_Project..CovidDeaths$
ORDER BY 1,2

-- LOOKING AT TOTAL CASES VS TOTAL DEATHS
-- IN OUR LOCATION

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Death_Percentage
FROM Portfolio_Project..CovidDeaths$
WHERE location LIKE '%INDIA%'
AND continent IS NOT NULL
ORDER BY 1,2

-- LOOKING AT TOTAL_CASES VS PUPULATIONS
-- PERCENTAGE OF POPULATION GOT COVID

SELECT location,date,population,total_cases,(total_cases/population)*100 AS PercentPopulationInfected
FROM Portfolio_Project..CovidDeaths$
ORDER BY 1,2

-- LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

SELECT location,population,MAX(total_cases) AS highest_count,MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM Portfolio_Project..CovidDeaths$
--WHERE location LIKE '%INDIA%'
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC

-- SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

SELECT location,MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- DEATH COUNT BY CONTINENT

SELECT location,MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths$
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- CONTINENTS WITH HIGHEST DEATH COUNT PER POPULATION

SELECT continent,MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- WORLD WIDE NUMBERS

SELECT SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS INT)) AS total_deaths,SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM Portfolio_Project..CovidDeaths$
--WHERE location LIKE '%INDIA%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2


SELECT * FROM Portfolio_Project..CovidVaccinations$

-- LET'S JOIN THESE
-- LOOKING AT TOTAL POPULATION VS VACCINATIONS

-- USE CTE

;WITH popvsvac (Continent , Location,date,population,new_vaccinations,RollingVaccinationCount)
AS
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingVaccinationCount
FROM Portfolio_Project..CovidDeaths$ dea
JOIN Portfolio_Project..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingVaccinationCount/population)*100 AS RollingVaccinationCount_Percentage
FROM PopvsVac



--TEMP TABLE

CREATE TABLE #PercentPopulationVaccinated(
continent NVARCHAR(255),
location NVARCHAR(255),
date DATETIME,
population NUMERIC,
new_vaccinations NUMERIC,
RollingVaccinationCount NUMERIC
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingVaccinationCount
FROM Portfolio_Project..CovidDeaths$ dea
JOIN Portfolio_Project..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
SELECT *, (RollingVaccinationCount/population)*100 AS RollingVaccinationCount_Percentage
FROM #PercentPopulationVaccinated


--CREATING VIEW

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingVaccinationCount
FROM Portfolio_Project..CovidDeaths$ dea
JOIN Portfolio_Project..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT * FROM 
PercentPopulationVaccinated
