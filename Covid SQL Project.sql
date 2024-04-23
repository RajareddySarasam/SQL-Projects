-- Viewing Datasets

select * from SQL_PROJECT..CovidDeaths 
select * from SQL_PROJECT..CovidVaccinations 


--Selecting columns we are going to use for Analysis

select location,date,total_cases,new_cases,total_deaths,population
from SQL_PROJECT..CovidDeaths


--Let's Total_cases vs Total_Deaths in our 'INDIA' 
--And DeathPercentage shows likelihood of Being Dead due to Covid in INDIA

select location,date,total_cases,total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from SQL_PROJECT..CovidDeaths 
where location like '%india%'
order by date


--Let's Look Total_cases vs Population in INDIA
--It will help us to Understand What percent of people were effected by Covid

select location,date,population,total_cases,
(total_cases/population)*100 as covidCasesPercentage
from SQL_PROJECT..CovidDeaths 
where location like '%india%'
order by date


--Let's Look  at countries with Highest Infection Rate in 'WORLD' ordered in Descending order

select location as country,AVG(population) as Population,MAX(total_cases) as HighestInfectionCount,
(MAX(total_cases)/AVG(population))*100 as PercentPopulationInfected
from SQL_PROJECT..CovidDeaths 
group by location order by covidCasesPercentage desc


--Let's look at Countries with highest Death Count
--Just Noticed that total_deaths column is Varchar() Datatype

select location as country,max(cast(total_deaths as int)) as TotalDeathCount
from SQL_PROJECT..CovidDeaths 
--(Some entries of location are replaced by there continent.Leaving continent column empty
--Where removing Them)
where continent is not null							
group by location order by TotalDeathCount desc


--Let's Compare them By thier Continent

select continent,sum(cast(total_deaths as int)) as TotalContinentDeathCount
from SQL_PROJECT..CovidDeaths 
where continent is not null							
group by continent order by TotalContinentDeathCount desc


--Global Covid Cases And Covid Deaths

select sum(new_cases) as TotalCases,sum(cast(new_deaths as int)) as TotalDeaths
,sum(cast(new_deaths as int))/sum(new_cases) as GlobalDeathPercent
from SQL_PROJECT..CovidDeaths 
where continent is not null	


--Global Numbers of Newcases and NewDeaths per  Day

select Date,sum(new_cases) as TotalCases,sum(cast(new_deaths as int)) as TotalDeaths
,sum(cast(new_deaths as int))/sum(new_cases) as GlobalDeathPercent
from SQL_PROJECT..CovidDeaths 
where continent is not null	
group by date order by date 


--Let's Manipulate the Vaccination Dataset 
--calculating the cummulative Deaths per country

select dea.continent,dea.location,dea.date ,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date ) as
CummulativeVaccinationCount
from SQL_PROJECT..CovidVaccinations vac join SQL_PROJECT..CovidDeaths dea 
on dea.date=vac.date and dea.location =vac.location 
where dea.continent is not null
order by 2,3


--Let's Store it in a Table 

--Creating Table
Drop Table if exists CountryCummulativeDeaths
Create Table CountryCummulativeDeaths
(
continent varchar(50),
location varchar(50),
Date date,
Population numeric,
New_vaccinations numeric,
CummulativeVaccinationCount numeric
)
--Inserting Data into Table
insert into CountryCummulativeDeaths
select dea.continent,dea.location,dea.date ,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date ) as
CummulativeVaccinationCount
from SQL_PROJECT..CovidVaccinations vac join SQL_PROJECT..CovidDeaths dea 
on dea.date=vac.date and dea.location =vac.location 
where dea.continent is not null
order by 2,3

--Displaying the table

select * from CountryCummulativeDeaths


--Let's Create a View 

Create view CountryCummulativeDeathsView 
as select
 dea.continent,dea.location,dea.date ,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date ) as
CummulativeVaccinationCount
from SQL_PROJECT..CovidVaccinations vac join SQL_PROJECT..CovidDeaths dea 
on dea.date=vac.date and dea.location =vac.location 
where dea.continent is not null

--For Droping Table,View
Drop Table CountryCummulativeDeaths
Drop View CountryCummulativeDeathsView


