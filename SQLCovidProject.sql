use sqlproject;

-- To show total deaths by covid till (25-02-2023)
select location,count(total_deaths) from coviddeaths group by 1;

-- To look total deaths vs total cases 
select location,date,(total_cases-total_deaths) as RecoveredCases,total_deaths,total_cases,(total_deaths/total_cases)*100 as RatioOfTotalDeathByTotalCases from coviddeaths order by 1,2;

-- To look at total_cases vs population
select location,population,total_deaths,total_cases,(total_cases/population)*100 as RatioOfTotalDeathByTotalCases from coviddeaths order by location,total_cases;

-- To check which country has max infected cases
select location,population, MAX(total_cases) as InfectedCases  from coviddeaths group by 1,2 order by InfectedCases desc;

-- To check percentage of total deaths per population for countries
select location,population,max(total_deaths) as Total_Deaths_Till_Day,round((max(total_deaths)/population)*100,4) as PercentageOfDeathCountPerPopulation from coviddeaths where continent is not null group by location,population order by Total_Deaths_Till_Day;


select * from covidvaccinations;

-- covid vaccinations table to see percentage of people who are vaccinated once, vaccinated fully out of total population of a country
select cv.location,cv.population,max(cv.people_vaccinated) as VaccinatedOnce,round((max(cv.people_vaccinated)/cv.population)*100,4) as PercentagePopulationVaccinatedOnce,max(cv.people_fully_vaccinated) as VaccinatedTwice,round((max(cv.people_fully_vaccinated)/cv.population)*100,4) as PercentagePopulationVaccinatedTwice,max(cv.total_vaccinations) as TotalVaccination,round((max(cv.total_vaccinations)/cv.population)*100,4) as PercentagePopulationVaccinatedEitherOnceOrTwice from covidvaccinations cv group by cv.location,cv.population;


-- Joining Both vaccination and death table to compare deaths stats and vaccination stats
select cv.continent,cv.location,cv.population,max(cd.new_cases) as TotalCasesOfCovid,round((max(cd.new_cases)/cv.population),4) as PercentageOfCovidCasesPerPopulaion,max(cv.people_vaccinated) as VaccinatedOnce,round((max(cv.people_vaccinated)/cv.population)*100,4) as PercentagePopulationVaccinatedOnce,max(cv.people_fully_vaccinated) as VaccinatedTwice,round((max(cv.people_fully_vaccinated)/cv.population)*100,4) as PercentagePopulationVaccinatedTwice,max(cv.total_vaccinations) as TotalVaccination,round((max(cv.total_vaccinations)/cv.population)*100,4) as PercentagePopulationVaccinatedEitherOnceOrTwice from coviddeaths cd join covidvaccinations cv on cd.location=cv.location and cd.date=cv.date group by cv.continent,cv.location,cv.population order by cv.continent;


-- to see new vaccinations in every country ordered by date
select cv.continent,cv.location,cv.date,cv.new_vaccinations from covidvaccinations cv order by cv.continent;
desc covidvaccinations;
-- Using Common table expression 

DROP Table if exists VaccinationOrder;
Create table VaccinationOrder(
continent nvarchar(255),
location nvarchar(255),
date nvarchar(255),
new_vaccinations nvarchar(255)
);
insert into VaccinationOrder select cv.continent,cv.location,cv.date,cv.new_vaccinations from covidvaccinations cv order by cv.continent;
select * from VaccinationOrder;
