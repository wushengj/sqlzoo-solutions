/*
table structure:
stops(id, name)
route(num, company, pos, stop)
*/

-- 1 
-- How many stops are in the database.
SELECT COUNT(id)
FROM stops;

-- 2 
-- Find the id value for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name = 'Craiglockhart';

-- 3 
-- Give the id and the name for the stops on the '4' 'LRT' service.
SELECT id, name
FROM stops JOIN route ON id = stop
WHERE num = '4' AND company = 'LRT';

-- 4 Routes and stops
-- notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) > 1;

-- 5 
-- Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = (SELECT id FROM stops WHERE name = 'London Road');

-- 6 
-- refer to stops by name rather than by number.
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road';

-- 7 
-- Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
