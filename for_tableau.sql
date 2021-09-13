
/* Indian Numbers */

-- Correction in datatypes of columns
ALTER TABLE CovidAnalysis..CovidVaccinations ALTER COLUMN date date;
ALTER TABLE CovidAnalysis..CovidDeath ALTER COLUMN population bigint;
ALTER TABLE CovidAnalysis..CovidDeath ALTER COLUMN total_cases int;
ALTER TABLE CovidAnalysis..CovidDeath ALTER COLUMN new_cases int;
ALTER TABLE CovidAnalysis..CovidDeath ALTER COLUMN total_deaths int;
ALTER TABLE CovidAnalysis..CovidDeath ALTER COLUMN new_deaths int;
ALTER TABLE CovidAnalysis..CovidDeath ALTER COLUMN reproduction_rate float;
ALTER TABLE CovidAnalysis..CovidVaccinations ALTER COLUMN total_tests int;
ALTER TABLE CovidAnalysis..CovidVaccinations ALTER COLUMN new_tests int;
ALTER TABLE CovidAnalysis..CovidVaccinations ALTER COLUMN tests_per_case float;
ALTER TABLE CovidAnalysis..CovidVaccinations ALTER COLUMN total_vaccinations bigint;
ALTER TABLE CovidAnalysis..CovidVaccinations ALTER COLUMN new_vaccinations int;
ALTER TABLE CovidAnalysis..CovidVaccinations ALTER COLUMN people_vaccinated bigint;
ALTER TABLE CovidAnalysis..CovidVaccinations ALTER COLUMN people_fully_vaccinated bigint;

-- Create a view for ease of implementation
CREATE OR ALTER VIEW IndianNumbers AS
SELECT a.location, a.date, b.population, b.total_cases, b.new_cases, b.total_deaths, b.new_deaths, b.reproduction_rate, a.total_tests, a.new_tests, a.tests_per_case, a.total_vaccinations, a.new_vaccinations, a.people_vaccinated as partially_vaccinated, a.people_fully_vaccinated as fully_vaccinated
FROM CovidAnalysis..CovidVaccinations a
JOIN CovidAnalysis..CovidDeath b
ON a.location = b.location and a.date = b.date
WHERE a.location LIKE '%ndia%'

-- Show new data types
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'IndianNumbers';




-- 1) Date Range
SELECT Min(date) as Start_date, Max(date) as End_date
FROM IndianNumbers;

-- 2) Total Cases time plot (cummulative nature)
SELECT date, total_cases
FROM IndianNumbers
ORDER BY date;

-- 3) New cases per day time plot
SELECT date, new_cases
FROM IndianNumbers
ORDER BY date;

-- 4) Max cases in a day
SELECT date, new_cases as Max_cases
FROM IndianNumbers
WHERE new_cases IN(SELECT MAX(new_cases) FROM IndianNumbers);

-- 5) Percent population infected till now (stat)
SELECT ROUND((MAX(CAST(total_cases as float))/Max(population)),4)*100 AS Percent_population_infected
FROM IndianNumbers;

-- 6) Total cases till now (stat)
SELECT MAX(total_cases) as Total_Cases
FROM IndianNumbers;

-- 7) First ever case registered (stat)
SELECT MIN(date) as First_case
FROM IndianNumbers
WHERE new_cases = 1;

-- 8) Days to reach first 100, 1000, 10,000, 100,000 cases (from the first case)
SELECT DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_cases >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_cases >= 100)) AS Days_to_100,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_cases >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_cases >= 1000)) AS Days_to_1000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_cases >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_cases >= 10000)) AS Days_to_10_000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_cases >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_cases >= 100000)) AS Days_to_100_000;


-- 9) Total deaths time plot (cummulative nature)
SELECT date, total_deaths
FROM IndianNumbers
ORDER BY date;

-- 10) New deaths per day time plot
SELECT date, new_deaths
FROM IndianNumbers
ORDER BY date;

-- 11) Maximum people died in a day (stat)
SELECT date, new_deaths as Maximum_deaths
FROM IndianNumbers
WHERE new_deaths IN(SELECT MAX(CAST(new_deaths as int)) FROM IndianNumbers);

-- 12) Percent infected died (stat)
SELECT ROUND((MAX(CAST(total_deaths as float))/MAX(total_cases)), 4)*100 as Percent_infected_died
FROM IndianNumbers

-- 13) Total deaths till now (stat)
SELECT MAX(total_deaths) as Total_deaths
FROM IndianNumbers;

-- 14) First ever death registered (stat)
SELECT MIN(date) as First_death
FROM IndianNumbers
WHERE total_deaths = 1;

-- 15) Days to reach 100, 1000, 10,000, 100,000 deaths (from 1st death)
SELECT DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_deaths >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_deaths >= 100)) AS Days_to_100,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_deaths >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_deaths >= 1000)) AS Days_to_1000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_deaths >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_deaths >= 10000)) AS Days_to_10_000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_deaths >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_deaths >= 100000)) AS Days_to_100_000;


-- 16) Latest reproduction rate
SELECT date, total_cases, reproduction_rate
FROM IndianNumbers
WHERE date IN(SELECT MAX(date) FROM IndianNumbers WHERE reproduction_rate IS NOT NULL);

-- 17) Total tests time plot (cummulative nature)
SELECT date, total_tests
FROM IndianNumbers
ORDER BY date;

-- 18) New tests per day time plot
SELECT date, new_tests
FROM IndianNumbers
ORDER BY date;

-- 19) Max tests in a day (stat)
SELECT date, new_tests as Max_tests
FROM IndianNumbers
WHERE new_tests IN(SELECT MAX(new_tests) FROM IndianNumbers);

-- 20) Percent population tested till now (stat)
SELECT ROUND((MAX(CAST(total_tests as float))/Max(population)),4)*100 AS Percent_population_tested
FROM IndianNumbers;

-- 21) Total tests till now (stat)
SELECT MAX(total_tests) as Total_Cases
FROM IndianNumbers;

-- 22) First ever test done (stat)
SELECT MIN(date) as First_test
FROM IndianNumbers
WHERE new_tests >= 1;

-- 23) Days to reach first 100, 1000, 10,000, 100,000 cases (from the first case)
SELECT DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_tests >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_tests >= 100)) AS Days_to_100,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_tests >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_tests >= 1000)) AS Days_to_1000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_tests >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_tests >= 10000)) AS Days_to_10_000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_tests >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_tests >= 100000)) AS Days_to_100_000;


-- 24) Total vaccinations time plot (cummulative nature)
SELECT date, total_vaccinations
FROM IndianNumbers
ORDER BY date;

-- 25) New vaccinations per day time plot
SELECT date, new_vaccinations
FROM IndianNumbers
ORDER BY date;

-- 26) Max vaccinated in a day (stat)
SELECT date, new_vaccinations as Max_vaccinated
FROM IndianNumbers
WHERE new_vaccinations IN(SELECT MAX(new_vaccinations) FROM IndianNumbers);

-- 27) Percent population vaccinated till now (stat)
SELECT ROUND((MAX(CAST(total_vaccinations as float))/Max(population)),4)*100 AS Percent_population_vaccinated
FROM IndianNumbers;

-- 28) Total vaccinated till now (stat)
SELECT MAX(total_vaccinations) as Total_Cases
FROM IndianNumbers;

-- 29) Vaccination starting date (stat)
SELECT MIN(date) as First_vaccination
FROM IndianNumbers
WHERE new_vaccinations >= 1;

-- 30) Days to reach first 100, 1000, 10,000, 100,000 cases (from the first case)
SELECT DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_vaccinations >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_vaccinations >= 100)) AS Days_to_100,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_vaccinations >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_vaccinations >= 1000)) AS Days_to_1000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_vaccinations >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_vaccinations >= 10000)) AS Days_to_10_000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM IndianNumbers WHERE total_vaccinations >= 1),
				(SELECT MIn(date) FROM IndianNumbers WHERE total_vaccinations >= 100000)) AS Days_to_100_000;


-- 31) Percent population vaccinated partially or fully
SELECT ROUND((MAX(CAST(partially_vaccinated as float))/MAX(population)), 4)*100 as Percent_people_partially_vaccinated,
	   ROUND((MAX(CAST(fully_vaccinated as float))/MAX(population)), 4)*100 as Percent_people_fully_vaccinated
FROM IndianNumbers

-- 32) Percent vaccinated partially or fully
SELECT ROUND(MAX(CAST(partially_vaccinated as float))/MAX(total_vaccinations), 4)*100 as Percent_vaccinated_partially,
	   ROUND(MAX(CAST(fully_vaccinated as float))/MAX(total_vaccinations), 4)*100 as Percent_vaccinated_fully
FROM IndianNumbers


/* Global Numbers */

-- Create view for ease of implementation
CREATE OR ALTER VIEW GlobalNumbers AS
SELECT a.location, a.continent, a.date, b.population, b.total_cases, b.new_cases, b.total_deaths, b.new_deaths, b.reproduction_rate, a.total_tests, a.new_tests, a.tests_per_case, a.total_vaccinations, a.new_vaccinations, a.people_vaccinated as partially_vaccinated, a.people_fully_vaccinated as fully_vaccinated
FROM CovidAnalysis..CovidVaccinations a
JOIN CovidAnalysis..CovidDeath b
ON a.location = b.location and a.date = b.date


-- 33) Total Cases time plot (cummulative nature)
SELECT location, date, total_cases
FROM GlobalNumbers
WHERE location LIKE 'world'
ORDER BY 2;

-- 34) New cases per day time plot
SELECT location, date, new_cases
FROM GlobalNumbers
WHERE location LIKE 'world'
ORDER BY 2;

-- 35) Max cases in a day
SELECT location, MAX(new_cases) as Max_cases_aday
FROM GlobalNumbers
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;

-- 36) Percent population infected till now (stat)
SELECT ROUND((MAX(CAST(total_cases as float))/Max(population)),4)*100 AS Percent_population_infected
FROM GlobalNumbers
WHERE location = 'world';
-- By country
SELECT location, ROUND((MAX(CAST(total_cases as float))/Max(population)),4)*100 AS Percent_population_infected
FROM GlobalNumbers
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;

-- 37) Total cases till now (stat)
SELECT MAX(total_cases) as Total_Cases
FROM GlobalNumbers
WHERE location = 'world';
-- By country
SELECT location, MAX(total_cases) as Total_Cases
FROM GlobalNumbers
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;

-- 38) First ever case registered (stat)
-- Firstly affected countires
SELECT location, MIN(date) as First_case
FROM GlobalNumbers
WHERE continent IS NOT NULL AND total_cases >= 1
GROUP BY location
ORDER BY 2;

-- 39) Days to reach first 100, 1000, 10,000, 100,000 cases (from the first case)
SELECT DATEDIFF(DAY, 
				(SELECT MIN(date) FROM GlobalNumbers WHERE total_cases >= 1 AND location = 'world'),
				(SELECT MIn(date) FROM GlobalNumbers WHERE total_cases >= 100 AND location = 'world')) AS Days_to_100,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM GlobalNumbers WHERE total_cases >= 1 AND location = 'world'),
				(SELECT MIn(date) FROM GlobalNumbers WHERE total_cases >= 1000 AND location = 'world')) AS Days_to_1000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM GlobalNumbers WHERE total_cases >= 1 AND location = 'world'),
				(SELECT MIn(date) FROM GlobalNumbers WHERE total_cases >= 10000 AND location = 'world')) AS Days_to_10_000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM GlobalNumbers WHERE total_cases >= 1 AND location = 'world'),
				(SELECT MIn(date) FROM GlobalNumbers WHERE total_cases >= 100000 AND location = 'world')) AS Days_to_100_000;

-- 40) Total deaths time plot (cummulative nature)
SELECT date, total_deaths
FROM GlobalNumbers
WHERE location = 'world'
ORDER BY date;

-- 41) New deaths per day time plot
SELECT date, new_deaths
FROM GlobalNumbers
WHERE location = 'world'
ORDER BY date;

-- 42) Maximum people died in a day (stat)
SELECT location, MAX(new_deaths) as Max_deaths_aday
FROM GlobalNumbers
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;


-- 43) Percent infected died (stat)
SELECT ROUND((MAX(CAST(total_deaths as float))/Max(total_cases)),4)*100 AS Percent_infected_died
FROM GlobalNumbers
WHERE location = 'world';
-- By country
SELECT location, ROUND((MAX(CAST(total_deaths as float))/Max(total_cases)),4)*100 AS Percent_infected_died
FROM GlobalNumbers
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;

-- 44) Total deaths till now (stat)
SELECT MAX(total_deaths) as Total_deaths
FROM GlobalNumbers
WHERE location = 'world';
-- By country
SELECT TOP 10 location, MAX(total_deaths) as Total_deaths
FROM GlobalNumbers
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;

-- 45) First ever death registered (stat)
-- Firstly affected countires
SELECT location, MIN(date) as First_death
FROM GlobalNumbers
WHERE continent IS NOT NULL AND total_deaths >= 1
GROUP BY location
ORDER BY 2;

-- 46) Days to reach 100, 1000, 10,000, 100,000 deaths (from 1st death)
SELECT DATEDIFF(DAY, 
				(SELECT MIN(date) FROM GlobalNumbers WHERE total_deaths >= 1 AND location = 'world'),
				(SELECT MIn(date) FROM GlobalNumbers WHERE total_deaths >= 100 AND location = 'world')) AS Days_to_100,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM GlobalNumbers WHERE total_deaths >= 1 AND location = 'world'),
				(SELECT MIn(date) FROM GlobalNumbers WHERE total_deaths >= 1000 AND location = 'world')) AS Days_to_1000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM GlobalNumbers WHERE total_deaths >= 1 AND location = 'world'),
				(SELECT MIn(date) FROM GlobalNumbers WHERE total_deaths >= 10000 AND location = 'world')) AS Days_to_10_000,
	   DATEDIFF(DAY, 
				(SELECT MIN(date) FROM GlobalNumbers WHERE total_deaths >= 1 AND location = 'world'),
				(SELECT MIn(date) FROM GlobalNumbers WHERE total_deaths >= 100000 AND location = 'world')) AS Days_to_100_000;


-- 47) Latest reproduction rate
SELECT date, total_cases, reproduction_rate
FROM GlobalNumbers
WHERE date IN(SELECT MAX(date) FROM GlobalNumbers WHERE reproduction_rate IS NOT NULL)
	AND location = 'world';
-- Country wise (Most contagious country right now)
SELECT TOP 10 location, date, total_cases, reproduction_rate
FROM GlobalNumbers
WHERE continent IS NOT NULL AND date IN(SELECT MAX(date) FROM GlobalNumbers WHERE reproduction_rate IS NOT NULL)
ORDER BY 4 DESC;

-- 48) New tests per day time plot
SELECT date, SUM(new_tests) as new_tests
FROM GlobalNumbers
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

-- 49) Max tests in a day (stat)
-- Country wise
SELECT TOP 10 location, MAX(new_tests) AS Max_tests
FROM GlobalNumbers
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;

-- 50) Percent population tested till now (stat)
-- By country
SELECT location, ROUND((MAX(CAST(total_tests as float))/Max(population)),4)*100 AS Percent_population_tested
FROM GlobalNumbers
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;

-- 51) First ever test done (stat)
-- Country wise
SELECT location, MIN(date) as First_test
FROM GlobalNumbers
WHERE new_tests >= 1 AND continent IS NOT NULL
GROUP BY location
ORDER BY 2;

-- 52) Total vaccinations time plot (cummulative nature)
SELECT date, total_vaccinations
FROM GlobalNumbers
WHERE location = 'world'
ORDER BY date;

-- 53) New vaccinations per day time plot
SELECT date, new_vaccinations
FROM GlobalNumbers
WHERE location = 'world'
ORDER BY date;

-- 54) Max vaccinated in a day (stat)
-- Country wise
SELECT location, MAX(new_vaccinations) AS Max_vaccinated_aday
FROM GlobalNumbers
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;

-- 55) Vaccination starting date (stat)
-- Country wise
SELECT location, MIN(date) as First_vaccination
FROM GlobalNumbers
WHERE new_vaccinations >= 1 AND continent IS NOT NULL
GROUP BY location
ORDER BY 2;

-- 56) Percent population vaccinated partially or fully
SELECT ROUND((MAX(CAST(partially_vaccinated as float))/MAX(population)), 4)*100 as Percent_people_partially_vaccinated,
	   ROUND((MAX(CAST(fully_vaccinated as float))/MAX(population)), 4)*100 as Percent_people_fully_vaccinated
FROM GlobalNumbers
WHERE location  = 'world';
-- COuntry wise
SELECT location, ROUND((MAX(CAST(partially_vaccinated as float))/MAX(population)), 4)*100 as Percent_people_partially_vaccinated,
	   ROUND((MAX(CAST(fully_vaccinated as float))/MAX(population)), 4)*100 as Percent_people_fully_vaccinated
FROM GlobalNumbers
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 3 DESC;