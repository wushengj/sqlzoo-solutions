/*
 table structure: world(name, continent, area, population, gdp)
*/

-- Basics(SELECT basics)
-- 1
-- Show the population of Germany
SELECT population FROM world
WHERE name = 'Germany';

-- 2
-- Show the name and the population for 'Sweden', 'Norway' and 'Denmark'.
SELECT name, population FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark');

-- 3
-- Show the country and the area for countries with an area between 200,000 and 250,000.
SELECT name, area FROM world
WHERE area BETWEEN 200000 AND 250000;


-- Quiz
-- CEECC CC


-- Tutorial(SELECT from world)
-- 1 Introduction
-- Show the name, continent and population of all countries.
SELECT name, continent, population 
FROM world;

-- 2 Large Countries
-- Show the name for the countries that have a population of at least 200 million.
SELECT name
FROM world
WHERE population > 200000000 ;

-- 3 Per capita GDP
-- Give the name and the per capita GDP for those countries with a population of at least 200 million.
SELECT name, gdp/population AS perCapitaGDP
FROM world
WHERE population > 200000000;

-- 4 South America In millions
-- Show the name and population in millions for the countries of the continent 'South America'.
SELECT name, population/1000000 AS population_M
FROM world
-- v1
WHERE continent = 'South America';
-- v2
WHERE continent in ('South America');

-- 5 France, Germany, Italy
-- Show the name and population for France, Germany, Italy
SELECT name, population
FROM world
-- v1
WHERE name in ('France', 'Germany', 'Italy');
-- v2
WHERE name = 'France' OR name = 'Germany' OR name = 'Italy';

-- 6 United
-- Show the countries which have a name that includes the word 'United'
SELECT name
FROM world
WHERE name LIKE '%United%';

-- 7 Two ways to be big
-- Show the countries that are big by area or big by population. Show name, population and area.
SELECT name, population, area
FROM world
WHERE area > 3000000 OR population > 250000000;

-- 8 One or the other (but not both)
-- Show the countries that are big by area (more than 3 million) or big by population (more than 250 million) but not both. Show name, population and area.
SELECT name, population, area
FROM world
WHERE (area > 3000000 AND population <= 250000000) OR (area <= 3000000 AND population > 250000000);

-- 9 Rounding
-- For South America show population in millions and GDP in billions both to 2 decimal places
SELECT name, ROUND(population/1000000, 2) AS population_M, ROUND(GDP/1000000000, 2) AS GDP_B 
FROM world
WHERE continent = 'South America';

-- 10 Trillion dollar economies
-- Show per-capita GDP for the trillion dollar countries to the nearest $1000.
SELECT name, ROUND(gdp/population, -3) AS perCapitaGDP
FROM world
WHERE gdp > 1000000000000;

-- 11 Name and capital have the same length
-- Show the name and capital where the name and the capital have the same number of characters.
SELECT name, capital
FROM world
WHERE LEN(name) = LEN(capital);

--12 Matching name and capital
-- Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word.
SELECT name, capital
FROM world
WHERE LEFT(name, 1) = LEFT(capital, 1) AND name <> capital;

-- 13 All the vowels
-- Find the country that has all the vowels and no spaces in its name.
SELECT name
FROM world
WHERE name LIKE '%a%' AND name LIKE '%e%' AND name LIKE '%i%' AND name LIKE '%o%' AND name LIKE '%u%' AND name NOT LIKE '% %';


-- Nested(SELECT from SELECT tutorial)
-- 1 Bigger than Russia
-- List each country name where the population is larger than that of 'Russia'.
SELECT name 
FROM world
WHERE population >
    (SELECT population
    FROM world
    WHERE name='Russia');

-- 2 Richer than UK
-- Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name
FROM world
WHERE continent = 'Europe'
    AND gdp/population > 
    (SELECT gdp/population
    FROM world
    WHERE name = 'United Kingdom');

-- 3 Neighbours of Argentina and Australia
-- List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
SELECT name, continent
FROM world
WHERE continent IN (SELECT continent FROM world WHERE name = 'Argentina' OR name = 'Australia')
ORDER BY name;

-- 4 Between Canada and Poland
-- Which country has a population that is more than Canada but less than Poland? Show the name and the population.
SELECT name, population
FROM world
WHERE population > (SELECT population 
                    FROM world
                    WHERE name = 'Canada')
      AND population < (SELECT population
                        FROM world 
                        WHERE name = 'Poland');

--! 5 Percentages of Germany
-- Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
SELECT name, CONCAT(ROUND(100*population/(SELECT population 
                                      FROM world 
                                      WHERE name = 'Germany'), 0), '%') AS percentage
FROM world
WHERE continent = 'Europe';

-- 6 Bigger than every country in Europe
-- Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
SELECT name
FROM world
WHERE gdp > ALL(SELECT gdp 
                FROM world 
                WHERE continent = 'Europe' AND gdp IS NOT null);

-- 7 Largest in each continent
-- Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, area 
FROM world x
WHERE area >= ALL
    (SELECT area 
    FROM world y
    WHERE y.continent = x.continent
          AND area > 0);

-- 8 First country of each continent (alphabetically)
-- List each continent and the name of the country that comes first alphabetically.
SELECT continent, name
FROM world x
WHERE name <= ALL(SELECT name 
                  FROM world y 
                  WHERE x.continent = y.continent);

--! 9 Difficult Questions That Utilize Techniques Not Covered In Prior Sections
-- Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
SELECT name, continent, population
FROM world x
WHERE 25000000 > ALL(SELECT population 
                    FROM world y 
                    WHERE x.continent = y.continent AND y.population IS NOT null);

-- 10 
-- Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
SELECT name, continent
FROM world x
WHERE population / 3 > ALL(SELECT population 
                           FROM world y 
                           WHERE x.name != y.name AND x.continent = y.continent AND population IS NOT null);


-- Quiz
-- CBADB BB