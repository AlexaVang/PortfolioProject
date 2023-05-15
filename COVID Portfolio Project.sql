Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order By 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order By 3,4

-- Select Data that we are going to be using

 Select Location, Date, Total_Cases, New_Cases, Total_Deaths, Population
 From PortfolioProject..CovidDeaths
 Where continent is not null
 Order By 1,2

 -- Looking at Total Cases vs. Total Deaths
 -- Shows likelihood of dying if you contract covid in your country

 Select Location, Date, Total_Cases, Total_Deaths, (Total_Deaths/Total_Cases) * 100 as DeathPercentage
 From PortfolioProject..CovidDeaths
 Where continent is not null
 Where Location like '%states%'
 Order By 1,2

 -- Looking at Total Cases vs Population
 -- Shows what percentage of population got covid

 Select Location, Date, Population, Total_Cases, (Total_Cases/Population) * 100 as PercentPopulationInfected
 From PortfolioProject..CovidDeaths
 Where continent is not null
 --Where Location like '%states%'
 Order By 1,2


 -- Looking at countries with highest infection rate compared to population

 Select Location, Population, MAX(Total_Cases) as HighestInfectionCount, MAX((Total_Cases/Population)) * 100 as PercentPopulationInfected
 From PortfolioProject..CovidDeaths
 Where continent is not null
 --Where Location like '%states%'
 Group By Location, Population
 Order By PercentPopulationInfected desc

 -- Showing the countries with the highest death count per population

 Select Location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
 From PortfolioProject..CovidDeaths
 Where continent is not null
 --Where Location like '%states%'
 Group By Location
 Order By TotalDeathCount desc

 -- Let's break things down by continent

 Select continent, MAX(cast(Total_Deaths as int)) as TotalDeathCount
 From PortfolioProject..CovidDeaths
 Where continent is not null
 --Where Location like '%states%'
 Group By continent
 Order By TotalDeathCount desc

 -- Showing continents with the highest death count per population

Select continent, MAX(cast(Total_Deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where Location like '%states%'
Where continent is not null
Group By continent
Order By TotalDeathCount desc

-- Global Numbers

 Select SUM(New_Cases) as Total_Cases, SUM(cast(New_Deaths as int)) as Total_Deaths, SUM(cast(New_Deaths as int))/SUM(New_Cases) * 100 as DeathPercentage
 From PortfolioProject..CovidDeaths
 Where continent is not null
 --Where Location like '%states%'
 --Group By Date
 Order By 1,2

 Select Date, SUM(New_Cases) as Total_Cases, SUM(cast(New_Deaths as int)) as Total_Deaths, SUM(cast(New_Deaths as int))/SUM(New_Cases) * 100 as DeathPercentage
 From PortfolioProject..CovidDeaths
 Where continent is not null
 --Where Location like '%states%'
 Group By Date
 Order By 1,2

 -- Looking at Total Population vs Vaccinations

 Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations
 , SUM(CONVERT(int, Vac.New_Vaccinations)) OVER (Partition by Dea.Location Order By Dea.Location, Dea.Date)
 as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/Population)*100
 From PortfolioProject..CovidDeaths Dea
 Join PortfolioProject..CovidVaccinations Vac
	ON Dea.Location = Vac.Location
	and Dea.Date = Vac.Date
 Where Dea.Continent is not null
 Order By 2,3

 -- USE CTE

 With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
 as
 (
  Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations
 , SUM(CONVERT(int, vac.New_Vaccinations)) OVER (Partition By Dea.Location Order By Dea.Location, Dea.Date)
 as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/Population)*100
 From PortfolioProject..CovidDeaths Dea
 Join PortfolioProject..CovidVaccinations Vac
	ON Dea.Location = Vac.Location
	and Dea.Date = Vac.Date
 Where Dea.Continent is not null
 --Order By 2,3
 )
 Select *, (RollingPeopleVaccinated/Population)*100
 From PopvsVac


 -- Temp Table

 DROP Table if exists #PercentPoplationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_Vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

 Insert Into #PercentPopulationVaccinated
 Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations
 , SUM(CONVERT(int, Vac.New_Vaccinations)) OVER (Partition By Dea.Location Order By Dea.Location, Dea.Date)
 as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/Population)*100
 From PortfolioProject..CovidDeaths Dea
 Join PortfolioProject..CovidVaccinations Vac
	ON Dea.Location = Vac.Location
	and Dea.Date = Vac.Date
 --Where Dea.Continent is not null
 --Order By 2,3

 Select *, (RollingPeopleVaccinated/Population)*100
 From #PercentPopulationVaccinated


 -- Creating View to store data for later visualizations

 Create View PercentPopulationVaccinated as
 Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations
 , SUM(CONVERT(int, Vac.New_Vaccinations)) OVER (Partition By Dea.Location Order By Dea.Location, Dea.Date)
 as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/Population)*100
 From PortfolioProject..CovidDeaths Dea
 Join PortfolioProject..CovidVaccinations Vac
	ON Dea.Location = Vac.Location
	and Dea.Date = Vac.Date
 Where Dea.Continent is not null
 --Order By 2,3


 Select *
 From PercentPopulationVaccinated