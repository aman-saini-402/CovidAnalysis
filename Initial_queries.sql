/* Date Range: FROM 28th Jan 2020 to 5th Sep 2021 */



Select *
From CovidAnalysis..CovidDeath
Order by 3

--Select *
--From CovidAnalysis..CovidVaccinations
--Order By 3,4


/* Columns used in the project */
Select location, date, total_cases, new_cases, total_deaths, population
From CovidAnalysis..CovidDeath
Order by 1,2


/* Looking at total cases Vs total deaths.
Shows likelihood of dying in respective country if contracted covid-19 */
SELECT location, date, total_cases, total_deaths, ROUND(total_deaths/total_cases, 3)*100 as percent_infected_died
FROM CovidAnalysis..CovidDeath
WHERE date IN(SELECT MAX(date) FROM CovidAnalysis..CovidDeath)
ORDER BY percent_infected_died DESC

	/* Looking at INDIA Vs the WORLD
	Shows likelihood of dying in INDAI if contracted covid-19 */
SELECT location, date, total_cases, total_deaths, ROUND(total_deaths/total_cases, 3)*100 as percent_infected_died
FROM CovidAnalysis..CovidDeath
WHERE date IN(SELECT MAX(date) FROM CovidAnalysis..CovidDeath) AND (location LIKE '%ndia%' OR location LIKE '%world%')
ORDER BY percent_infected_died DESC


/* Looking at total cases Vs population.
Shows likelihood of contracting covid in respective country */
SELECT location, date, total_cases, population, ROUND(total_cases/population, 3)*100 as percent_population_infected
FROM CovidAnalysis..CovidDeath
WHERE date IN(SELECT MAX(date) FROM CovidAnalysis..CovidDeath)
ORDER BY percent_population_infected DESC

	/* Looking at INDIA Vs the WORLD
	Shows likelihood of contracting covid in INDAI */
SELECT location, date, total_cases, population, ROUND(total_cases/population, 3)*100 as percent_population_infected
FROM CovidAnalysis..CovidDeath
WHERE date IN(SELECT MAX(date) FROM CovidAnalysis..CovidDeath) AND (location LIKE '%ndia%' OR location LIKE '%world%')
ORDER BY percent_population_infected DESC

	--Just looking at INDIA positive_rate
SELECT location, date, population, total_cases, (total_cases/population)*100 as positive_rate
FROM CovidAnalysis..CovidDeath
WHERE location LIKE '%ndia%'
ORDER BY 2


-- LOOKING AT GLOBAL NUMBERS

/* Total deaths per continent */
SELECT location, MAX(cast(total_cases as int)) as total_death_count
FROM CovidAnalysis..CovidDeath
WHERE continent IS NULL
GROUP BY location
ORDER BY total_death_count DESC


/* Death percentage per continent */
SELECT location, ROUND(total_deaths/total_cases, 3)*100 as percent_infected_died
FROM CovidAnalysis..CovidDeath
WHERE continent IS NULL AND date IN(SELECT MAX(date) FROM CovidAnalysis..CovidDeath)
ORDER BY percent_infected_died DESC


/* Infected percentage per continent */
SELECT location, ROUND(total_cases/population, 3)*100 as percent_population_infected
FROM CovidAnalysis..CovidDeath
WHERE continent IS NULL AND date IN(SELECT MAX(date) FROM CovidAnalysis..CovidDeath)
ORDER BY percent_population_infected DESC




/* Joining death and vaccination data */



/* Looking at total vaccinated Vs population */
SELECT dea.location, dea.date, ROUND(vac.people_vaccinated/dea.population, 4)*100 as percent_population_vaccinated
FROM CovidAnalysis..CovidDeath dea
JOIN CovidAnalysis..CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.date IN(SELECT MAX(date) FROM CovidAnalysis..CovidDeath)
ORDER BY percent_population_vaccinated DESC

	/* Looking at total vaccinated percentage in INDIA */
SELECT dea.location, dea.date, ROUND(vac.people_vaccinated/dea.population, 4)*100 as percent_population_vaccinated
FROM CovidAnalysis..CovidDeath dea
JOIN CovidAnalysis..CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.date IN(SELECT MAX(date) FROM CovidAnalysis..CovidDeath) AND (dea.location LIKE '%ndia%' OR dea.location LIKE '%world%')
ORDER BY percent_population_vaccinated DESC








/* Creating View for visualizations */
CREATE OR ALTER VIEW PercentPopulationVaccinated AS
SELECT dea.location, dea.date, ROUND(vac.people_vaccinated/dea.population, 4)*100 as percent_population_vaccinated
FROM CovidAnalysis..CovidDeath dea
JOIN CovidAnalysis..CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.date IN(SELECT MAX(date) FROM CovidAnalysis..CovidDeath)

SELECT *
FROM PercentPopulationVaccinated
ORDER BY percent_population_vaccinated DESC