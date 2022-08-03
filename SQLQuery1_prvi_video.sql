-- COVID DEATHS 
Select *
From PotrfolioProject..CovidDeaths$
order by 3,4

--Izbacujemo kontinente iz podataka

Select *
From PotrfolioProject..CovidDeaths$
Where continent is not null
order by 3,4



--Biramo podatke koje cemo da koristimo

Select Location, date, total_cases, new_cases, total_deaths, population
From PotrfolioProject..CovidDeaths$
Where continent is not null
order by 1,2

--Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PotrfolioProject..CovidDeaths$
Where continent is not null
order by 1,2

-- Poredjenje Total Cases vs Total Deaths za drzavu Srbiju

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PotrfolioProject..CovidDeaths$
Where location = 'Serbia'
order by 1,2

--Poredjenje Total Cases vs Total Deaths za drzavu Hrvatsku

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PotrfolioProject..CovidDeaths$
Where location = 'Croatia'
order by 1,2


--Total Cases vs Population
-- Pokazuje postotak populacije koji se zarazi kovidom

Select Location, date, total_cases, Population, (total_cases/population)*100 as GotCovid
From PotrfolioProject..CovidDeaths$
Where location = 'Serbia'
order by 1,2

--Trazimo drzavu sa najvecim brojem zarazenih u odnosu na populaciju
--Sortiramo u odnosu na PercentPopulationInfected
-- desc = descending

Select Location, MAX(total_cases) as HighestInfectionCount, Population, Max((total_cases/population))*100 as PercentPopulationInfected
From PotrfolioProject..CovidDeaths$
Where continent is not null
Group by Location, population
order by PercentPopulationInfected desc

-- Trazimo drzave sa najvecom smrtnoscu u odnosu na populaciju

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PotrfolioProject..CovidDeaths$
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- POGLEDAJMO PODATKE U ODNOSU NA KONTINENTE (sto se tice najveceg broja smrtnosti)

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PotrfolioProject..CovidDeaths$
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- Gledamo podatke u odnosu na kontinente, citav svijet i Evropsku Uniju(Poredimo u odnosu na lokaciju)

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PotrfolioProject..CovidDeaths$
Where location not in ('Upper middle income','High income', 'Lower middle income','Low income','International') and continent is null
Group by location
order by TotalDeathCount desc

-- Poredjenje kontinenata sa najvecim brojem smtrnosti u odnosu na populaciju

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PotrfolioProject..CovidDeaths$
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- GLOBALNA SITUACIJA

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PotrfolioProject..CovidDeaths$
Where continent is not null
order by 1,2

-- Poredimo sada u odnosu na datum
--suma novih slucajeva koji se dodaju totalnom broju slucajeva
-- pomocu ovoga dobijamo globalan broj slucajeva u svakom danu

Select date, SUM(new_cases)--total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PotrfolioProject..CovidDeaths$
Where continent is not null
Group by date
order by 1,2

-- Procenat smrtnosti u odnosu na datum, poredimo kolone new_cases i new_deaths

Select date, SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(new_cases)/SUM(cast(new_deaths as int))*100 as DeathPercentage
From PotrfolioProject..CovidDeaths$
Where continent is not null
Group by date
order by 1,2

-- DOBIJANJE POTPUNOG BROJA SLUCAJEVA

Select  SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(new_cases)/SUM(cast(new_deaths as int))*100 as DeathPercentage
From PotrfolioProject..CovidDeaths$
Where continent is not null
order by 1,2


--COVID VACCINATIONS

Select *
From PotrfolioProject..CovidVaccinations$

--Spojimo date grupe podataka(lokacija i datum)

Select*
From PotrfolioProject..CovidDeaths$ dea
Join PotrfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
 

 -- Total Population vs Vaccination

 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
From PotrfolioProject..CovidDeaths$ dea
Join PotrfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 1,2,3


-- Podjela u odnosu na lokaciju(sum staje svaki put kad dodjemo do nove drzave, ne nastavlja se sabirati na dobijenu sumu)

 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date)
From PotrfolioProject..CovidDeaths$ dea
Join PotrfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 1,2,3

-- Redamo u odnosu na lokaciju u datum

 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date)
From PotrfolioProject..CovidDeaths$ dea
Join PotrfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 1,2,3

 
 --Pravimo novu tabelu

 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date)
 as RollingPeopleVaccinated
From PotrfolioProject..CovidDeaths$ dea
Join PotrfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 1,2,3

--Koristimo CTE, ovo je kako raste postotak vakcinisanih ljudi

With PopvsVac(Continent,Location,Date, Population, New_Vaccinations,RollingPeopleVaccinated)
as
(
 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date)
 as RollingPeopleVaccinated
From PotrfolioProject..CovidDeaths$ dea
Join PotrfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 1,2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE
DROP Table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentagePopulationVaccinated
 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date)
 as RollingPeopleVaccinated
From PotrfolioProject..CovidDeaths$ dea
Join PotrfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
--Where dea.continent is not null
--order by 1,2,3

Select *,(RollingPeopleVaccinated/Population)*100
From #PercentagePopulationVaccinated


--Kreirajmo View kako bi mogli pohraniti podatke za kasniju vizualizaciju

Create View PercentPopulationVaccinated1 as
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,dea.date)
 as RollingPeopleVaccinated
From PotrfolioProject..CovidDeaths$ dea
Join PotrfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 1,2,3


Select *
From PercentPopulationVaccinated1
