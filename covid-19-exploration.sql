/* Data Exploration of Covid 19 Pandemic Data 
 * Finding out what are the impacts of Covid 19 to the world, and how every country react to this Pandemic.
 * .
 * Dataset: https://ourworldindata.org/coronavirus */


-- Select the used data 

SELECT cd.location, cd.date, cd.total_cases, cd.new_cases, cd.total_deaths, cd.population
FROM CovidDeath cd ;



-- Find the percentage of total_cases and total_deaths

SELECT 
	cd.location, cd.date, cd.total_cases, cd.total_deaths,
	((cd.total_deaths / cd.total_cases) * 100) death_percentage
FROM CovidDeath cd 
WHERE cd.location LIKE 'Indonesia';



-- Find the percentage of total_cases and population

SELECT 
	cd.location, cd.date, cd.total_cases, cd.population, 
	((cd.total_cases / cd.population) * 100) percent_population_infected
FROM CovidDeath cd 
WHERE cd.location LIKE 'Indonesia' AND cd.continent <> '';



-- Find the country with the Highest percent infection rate compared to population

SELECT 
	cd.location, cd.population, MAX(cd.total_cases) highest_infection_rate, 
	MAX(((cd.total_cases / cd.population)) * 100) highest_percent_population_infected
FROM CovidDeath cd 
GROUP BY cd.location
WHERE cd.continent <> ''
ORDER BY highest_percent_population_infected DESC;



-- Find the highest total death for each countries

SELECT 
	cd.location, MAX(CAST(cd.total_deaths AS INT)) highest_total_deaths
FROM CovidDeath cd 
WHERE cd.continent <> ''
GROUP BY cd.location
ORDER BY highest_total_deaths DESC ;



-- Find the highest total death by continent

SELECT 
	cd.location, MAX(CAST(cd.total_deaths AS INT)) highest_total_deaths
FROM CovidDeath cd 
WHERE cd.continent = ''
GROUP BY cd.location
ORDER BY highest_total_deaths DESC ;



-- Find the total cases and deaths for each day

SELECT 
	CAST(cd.date AS DATE) date, SUM(cd.total_cases) total_cases, SUM(cd.total_deaths) total_deaths,
	(SUM(cd.total_deaths) / SUM(cd.total_cases) * 100) percent_of_deaths
FROM CovidDeath cd 
WHERE cd.continent <> ''
GROUP BY date;



-- Find the total_cases and total_deaths in the world

SELECT 
	SUM(cd.new_cases) total_cases, SUM(cd.new_deaths) total_deaths,
	(SUM(cd.new_deaths) / SUM(cd.new_cases) * 100) percent_of_deaths
FROM CovidDeath cd 
WHERE cd.continent <> '' ;



-- Find the total vaccinations from CovidVaccinations 

SELECT 
	cd.id, cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) total_vaccinations
FROM CovidDeath cd 
JOIN CovidVaccinations cv 
	ON cd.id = cv.id
WHERE cd.continent <> '';



-- Find the total_vaccinations percentage using CTE

WITH vaccinated AS
(SELECT 
	cd.id, cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) total_vaccinated
FROM CovidDeath cd 
JOIN CovidVaccinations cv 
	ON cd.id = cv.id
WHERE cd.continent <> '')
SELECT 
	*,
	((total_vaccinated / population) * 100) total_vaccinated_percentage
FROM vaccinated ;



-- Create view for Visualization

CREATE VIEW DateVaccinated AS 
SELECT 
	cd.id, cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) total_vaccinated
FROM CovidDeath cd 
JOIN CovidVaccinations cv 
	ON cd.id = cv.id
WHERE cd.continent <> '' ;

SELECT * FROM DateVaccinated dv ;
