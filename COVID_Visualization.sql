

-- THESE DATE WE ARE USING FOR VISUALIZATION

--1.

SELECT SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS INT)) AS total_deaths,SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM Portfolio_Project..CovidDeaths$
--WHERE location LIKE '%INDIA%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

--2.


SELECT location,SUM(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths$
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC

-- 3.

SELECT location,population,MAX(total_cases) AS HighestInfectioncount,MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM Portfolio_Project..CovidDeaths$
--WHERE location LIKE '%INDIA%'
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC

-- 4.

SELECT location,population,date,MAX(total_cases) AS HighestInfectioncount,MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM Portfolio_Project..CovidDeaths$
--WHERE location LIKE '%INDIA%'
WHERE continent IS NOT NULL
GROUP BY location,population,date
ORDER BY PercentPopulationInfected DESC


--5.

SELECT dea.continent,dea.location,dea.date,dea.population,MAX(vac.new_vaccinations) AS RollingVaccinationCount
FROM Portfolio_Project..CovidDeaths$ dea
JOIN Portfolio_Project..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent,dea.location,dea.date,dea.population
ORDER BY 1,2,3

--6.

SELECT SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS INT)) AS total_deaths,SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM Portfolio_Project..CovidDeaths$
--WHERE location LIKE '%INDIA%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

--7.

Select Location, date, population, total_cases, total_deaths
From Portfolio_Project..CovidDeaths$
--Where location like '%states%'
where continent is not null 
order by 1,2

--8.

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



