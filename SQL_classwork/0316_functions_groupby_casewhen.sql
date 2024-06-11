/* 

2024-03-16

DESC TABLE
SHOW COLUMNS IN TABLE
CAST ::
COUNT()
GROUP BY 
HAVING
LIKE, ILIKE
IN, NOT IN
BETWEEN
IS NULL, IS NOT NULL
IFNULL
CASE WHEN

STRING FUNCTIONS:
    SPLIT
    SPLIT_PART
    LENGTH LEN
    REPLACE
    SUBSTRING
    LOWER, UPPER
    LEFT, RIGHT

MATH FUNCTIONS:
    HAVERSINE
    ROUND
    FLOOR
    CEIL

DATE FUNCTIONS:
    TO_DATE
    DATE_FROM_PARTS
    DATEADD
    DATEDIFF
    EXTRACT


*/





---------------------------------------------------------

-- CAST - PŘETYPOVÁNÍ DATOVÉHO TYPU

---------------------------------------------------------
-- popise tabulku - datove typy
DESC TABLE TEROR; -- sloupec type
SHOW COLUMNS IN TABLE TEROR; -- sloupec data_type

-- Přetypování datového typu, použijeme funkci CAST
SELECT 1 as Cislo;
SELECT '1' as Text;  
SELECT CAST('1' AS INT);

-- Jiný zápis pomocí dvou dvojteček (::)
SELECT '1'::INT;

-- Chceme desetinné číslo
SELECT '1'::FLOAT;

-- Přetypování datového typu -  textovy řetězec
SELECT 1::VARCHAR ; -- STRING

-- Přetypování datového typu - datum
SELECT CURRENT_DATE();
SELECT '2021-03-13'::DATE; -- YYYY-MM-DD defaultně
SELECT '13.3.2021'::DATE;
SELECT '13/3/2021'::DATE;
SELECT '3/13/2021'::DATE;
SELECT '2021-03-13'::DATETIME;



// *** Cvičení: Z tabulky TEROR vyberte sloupec COUNTRY a přetypujte ho na textový řetězec.
-- Následně vyberte sloupec IDATE a přetypujte ho na textový řetězec.

SELECT COUNTRY::VARCHAR, IDATE::VARCHAR
FROM TEROR
;

SELECT COUNTRY::STRING, IDATE::STRING -- Same output
FROM TEROR
;





---------------------------------------------------------

-- PODMÍNKY: Zakladní operátory

---------------------------------------------------------

a = b
a <> b    =     a != b
a > b
a >= b
a < b
a <= b

-- Příklady TEXT
SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE CITY = 'Prague';
SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE CITY <> 'Prague';

-- Příklady čísla
SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE NKILL = 0;

SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE NKILL < 1;

SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE NKILL >= 50;


-- Testujeme podmínky za pomoci jednoduchého SELECTu

SELECT 'Podmínka platí'
WHERE 1=1
;

-- Otestujte, jestli '2' = 2
SELECT 'Podmínka platí'
WHERE '2' = 2 
;

-- Otestujte, jestli 1 + 4 - 2 / 2 je menší než 2 * 2
SELECT 'Podmínka platí'
WHERE (1 + 4 - 2 / 2) < 2 * 2
;

-- Otestujte, jestli 5 je menší nebo rovno 10
SELECT 'Podmínka platí'
WHERE 5 <= 10
;

-- Otestujte, jestli 500 (přecastováno na text) není rovno 10 (přecastováno na text)
SELECT 'Podmínka platí'
WHERE cast(500 as text) <> cast(10 as text)
;





-- UKOLY
// A Úkol 2.1  // Vyber z tabulky TEROR útoky, kde zemřel alespoň jeden terorista (NKILLTER). (jeden nebo více teroristů)      

SELECT *
FROM TEROR
WHERE NKILLTER >= 1
;

// B Úkol 2.2 // Zobraz jen sloupečky GNAME, COUNTRY_TXT, NKILL a všechny řádky (seřazené podle počtu mrtvých sestupně), na kterých je víc než 340 mrtvých (počet mrtvých je ve sloupci NKILL), sloupečky přejmenuj na ORGANIZACE, ZEME, POCET_MRTVYCH.

SELECT GNAME AS ORGANIZACE, COUNTRY_TXT AS ZEME, NKILL AS POCET_MRTVYCH
FROM TEROR
WHERE NKILL > 340
ORDER BY POCET_MRTVYCH DESC
;





---------------------------------------------------------

-- Porovnáváme více hodnot - čísla a textové řetězce
SELECT *
FROM TEROR
WHERE
    IYEAR IN (1990, 1998, 1999) OR
    CITY IN ('Prague', 'Brno', 'Bratislava')
 ;

-- Úkol: Vyberte sloupce IYEAR a EVENTID z tabulky TEROR pro záznamy, které se staly v letech 2016 a 2017.

SELECT IYEAR, EVENTID
FROM TEROR
WHERE IYEAR IN (2016, 2017)
;

-- Úkol: Vyber z tabulky TEROR útoky v Německu (Germany), kde zemřel alespoň jeden TERORista (NKILLter).  
SELECT *
FROM TEROR
WHERE
    COUNTRY_TXT = 'Germany'
    AND NKILLTER > 0
ORDER BY NKILLTER DESC
;

-- Pojďme se podívat na to, jak fungují závorky:
SELECT DISTINCT COUNTRY_TXT, CITY, SUMMARY
FROM TEROR
WHERE COUNTRY_TXT = 'India' AND CITY='Delina' OR CITY='Bara';

SELECT DISTINCT COUNTRY_TXT, CITY
FROM TEROR
WHERE COUNTRY_TXT = 'India' AND (CITY='Delina' OR CITY='Bara');


-- Příklad na podmínky a zároveň opakování funkce COUNT()
-- Spočítej počet záznamů v tabulce TEROR, 
-- kde bylo zraněno více než 1000 lidí nebo zabito více než 10 teroristů (v libovolném roce) nebo
-- kde bylo buď zabito více než 100 lidí a útok se stal v roce 2016 nebo
-- kde bylo zabito více nebo rovno než 110 lidí a útok se stal v roce 2017 

SELECT COUNT(*)
FROM TEROR
WHERE 1=1
    AND (NWOUND > 1000 OR NKILLTER > 10) 
    OR  NKILL > 100 AND IYEAR = 2016
    OR NKILL >= 110 AND IYEAR = 2017
;





---------------------------------------------------------

-- AGREGAČNÍ FUNKCE

---------------------------------------------------------                   
-- COUNT() - počet

select nkill
from teror
order by nkill desc nulls last
limit 1
;


-- Cvičení: Napiš dotaz, který vrátí z Tabulky TEROR:
  -- Počet různých měst ve sloupci CITY
  -- Minimální (nejmenší) datum ve sloupci IDATE
  -- Maximální počet mrtvých teroristů na jeden útok ve sloupci NKILLTER
  -- Průměrný počet zraněných na útok ze sloupce NWOUND
  -- Celkový počet zabitých osob v tabulce - sloupec NKILL

SELECT 
    COUNT(DISTINCT CITY) AS DISTINCT_CITIES, 
    MIN(IDATE) AS EARLIEST_EVENT,
    MAX(NKILLTER) AS TERRORISTS_KILLED,
    AVG(NWOUND) AS WOUNDED,
    SUM(NKILL) AS KILLED
FROM TEROR
;



---------------------------------------------------------                        
-- GROUP BY - vytváření skupin
--------------------------------------------------------                         

-- Všechny záznamy rozskupinkovány dle zemí
SELECT COUNTRY_TXT
FROM TEROR
GROUP BY COUNTRY_TXT
;

-- Kolik je záznamů v každé skupině?
SELECT COUNTRY_TXT, COUNT(*)
FROM TEROR
GROUP BY COUNTRY_TXT
ORDER BY COUNT(*) DESC 
;


-- Cvičení: Vypiš všechny regiony (REGION_TXT) a spočítej, kolik bylo v každém regionu útoků.

SELECT REGION_TXT, COUNT(*)
FROM TEROR
GROUP BY REGION_TXT
ORDER BY COUNT(*) DESC
;

-- Počet zabitych dle GNAME (TERORisticke organizace)
SELECT GNAME, -- skupina
       SUM(NKILL) -- agregace
FROM TEROR
GROUP BY GNAME;

-- podle GNAME a COUNTRY_TXT
SELECT GNAME, -- skupina
       COUNTRY_TXT, -- skupina 
       SUM(NKILL), -- agregace
       COUNT(NKILL) -- agregace
FROM TEROR
GROUP BY GNAME, COUNTRY_TXT;





-- UKOLY z KODIM.CZ ----------------------------------------------------------

// A // Zjisti počet obětí a raněných po letech a měsících

SELECT IYEAR, IMONTH, SUM(NKILL), SUM(NWOUND)
FROM TEROR
GROUP BY IYEAR, IMONTH
;


// B // Zjisti počet obětí a raněných v západní Evropě po letech a měsících

SELECT REGION_TXT, IYEAR, IMONTH, SUM(NKILL), SUM(NWOUND)
FROM TEROR
WHERE REGION_TXT = 'Western Europe'
GROUP BY REGION_TXT, IYEAR, IMONTH
;


// C // Zjisti počet útoků po zemích. Seřaď je podle počtu útoků sestupně

SELECT COUNTRY_TXT, COUNT(*) AS TOTAL_ATTACKS
FROM TEROR
GROUP BY COUNTRY_TXT
ORDER BY TOTAL_ATTACKS DESC
;


// D // Zjisti počet útoků po zemích a letech, seřaď je podle počtu útoků sestupně

SELECT COUNTRY_TXT, IYEAR, COUNT(*) AS TOTAL_ATTACKS
FROM TEROR
GROUP BY COUNTRY_TXT, IYEAR
ORDER BY TOTAL_ATTACKS DESC
;


// E // Kolik která organizace spáchala útoků zápalnými zbraněmi (weaptype1_txt = 'Incendiary'), 
    --  kolik při nich celkem zabila obětí, kolik zemřelo TERORistů a kolik lidí bylo zraněno (NKILL, NKILLter, nwound)
    
SELECT 
    GNAME
    ,COUNT(*) AS ATTACKS
    ,SUM(NKILL) AS KILLED
    ,SUM(NKILLTER) AS DEAD_TERRORISTS
    ,SUM(NWOUND) AS WOUNDED
FROM TEROR
WHERE WEAPTYPE1_TXT = 'Incendiary'
GROUP BY GNAME
ORDER BY ATTACKS DESC
;





---------------------------------------------------------                        

-- HAVING - možnost zapsat podmínky ke skupinám (GROUP BY)

---------------------------------------------------------                         

--- pocet mrtvych podle TERORisticke organizace kde je pocet obeti vetsi nez nula
SELECT 
    GNAME, 
    SUM(NKILL), 
FROM TEROR
GROUP BY GNAME
HAVING SUM(NKILL) > 0 -- selects gnames that killed someone. Can use aggregate functions in HAVING
ORDER BY SUM(NKILL) DESC
;

--- pocet mrtvych podle TERORisticke organizace kde je pocet obeti a pocet mrtvych TERORistu vetsi nez nula
SELECT 
    GNAME, 
    SUM(NKILL),
    SUM(NKILLTER)
FROM TEROR
GROUP BY GNAME
HAVING SUM(NKILL) > 0 AND SUM(NKILLTER) > 0
ORDER BY SUM(NKILL) DESC
;





-- UKOL KODIM.CZ ----------------------------------------------------------

// F // Stejné jako E, jen ve výsledném výpisu chceme jen organizace, které zápalnými útoky zabily 10 a více lidí.

SELECT 
    GNAME
    ,COUNT(*) AS ATTACKS
    ,SUM(NKILL) AS KILLED
    ,SUM(NKILLTER) AS DEAD_TERRORISTS
    ,SUM(NWOUND) AS WOUNDED
FROM TEROR
WHERE WEAPTYPE1_TXT = 'Incendiary'
GROUP BY GNAME
HAVING KILLED >= 10
ORDER BY KILLED DESC
;






---------------------------------------------------------                        
-- FUNKCE
---------------------------------------------------------
--- Ve světě databází jsou funkce programovatelné části kódu, které provádějí určité operace nebo výpočty nad daty v databázi.
--- Funkce jsou často používány pro transformaci dat, výpočty a zpracování dat
--- Funkce jako nadstavba (každá SQL flavor se může různit) -> dokumentace
------ Některé databázové systémy mohou nabízet rozšíření nebo vlastní funkce, které nejsou součástí standardního SQL a jsou specifické pro daný systém


---- jak zjistit datovy typ?

DESC TABLE TEROR;


---------------------------------------------------------                        
-- STRING FUNCTIONS
---------------------------------------------------------
-- Manipulace s textem
/*
SPLIT
LENGTH, LEN
REPLACE
SUBSTRING
LEFT
RIGHT
LOWER, UPPER
*/

-- SPLIT
SELECT SPLIT('127.0.0.1', '.')[1] -- 1 is the index -- counting from 0
       ,SPLIT_PART('127.0.0.1', '.',2) -- counting from 1
;

SELECT
    city
   ,SPLIT(city, ' ')
   ,ARRAY_SIZE(SPLIT(city, ' '))
   ,ARRAY_SIZE(SPLIT(city,' '))-1
   ,SPLIT(city, ' ')[ARRAY_SIZE(SPLIT(city,' '))-1]::STRING
FROM teror; -- vybere vsechny mesta a rozdeli je podle poctu slov 


-- UKOLY ----------------------------------------------------------
-- Vypiste vsechny utoky, ktere maji trislovne a vice slovne nazvy mest (city).
SELECT *
FROM TEROR
WHERE ARRAY_SIZE(SPLIT(city, ' ')) >= 3
;


-- LENGTH & REPLACE
SELECT LENGTH('12345'); -- textova hodnota
SELECT LENGTH(12345); -- ciselna hodnota
SELECT LENGTH('dobry den'); -- mezera je taky znak
SELECT LEN('dobry den');

SELECT country_txt, city
       ,REPLACE(city,' ','-')
FROM teror;


-- SUBSTRING & LOWER & UPPER
SELECT city 
       ,SUBSTRING(city,1,1) AS prvni_pismeno -- string, index_from, [index_to]; counting from 1
       ,SUBSTR(city,1,1) AS taky_prvni_pismeno 
       ,SUBSTRING(city,1,1) || SUBSTRING(city,2) -- SVISLÍTKO NEBOLI ROUŘÍTKO! -- concatenation
       ,LOWER(prvni_pismeno) || SUBSTRING(UPPER(city),2)
FROM teror; -- vybere mesto a jeho prvni pismeno


-- LEFT
SELECT city 
       ,LEFT(city,1) AS prvni_pismeno
FROM teror; -- vybere mesto a jeho prvni pismeno

-- RIGHT & UPPER
SELECT city, 
       UPPER(RIGHT(city,3)) AS posledni_tri_pismena 
FROM teror; -- vybere mesto a jeho posledni tri pismena v UPPERCASE



-- BONUS: CHARINDEX & POSITION
/*
SELECT 
    country_txt
    ,CHARINDEX('o',country_txt)
    ,POSITION('o',country_txt)
    ,POSITION('o' IN country_txt)
FROM teror;
*/
-- DALSI ZAJIMAVE FUNKCE: 
---- TRIM
---- TRANSLATE
/*
SELECT TRANSLATE(city,'o','Ö')
FROM teror;
*/



---------------------------------------------------------                        
-- MATH FUNCTIONS
---------------------------------------------------------
/*
HAVERSINE
ROUND
FLOOR
CEIL
*/

SELECT 
     latitude     --zeměpisná šířka
    ,longitude    --zeměpisná délka
FROM teror;

-- HAVERSINE
----HAVERSINE( lat1, lon1, lat2, lon2 )
SELECT 
     gname --název teroristicke skupiny
    ,city 
    ,iyear
    ,nkill
    ,summary
//    ,latitude 
//    ,longitude
    ,HAVERSINE(50.0833472, 14.4252625, latitude, longitude) AS vzdalenost_od_czechitas -- v km
FROM teror 
WHERE vzdalenost_od_czechitas < 100 -- novy sloupec muzeme pouzit v podmince
ORDER BY nkill DESC;


-- co jednotlive funkce delaji?
SELECT 
     ROUND(1.5)
    ,CEIL(1.5)
    ,FLOOR(1.5)
    ,TRUNC(1.5) --TRUNCATE
       
    ,ROUND(1.1)
    ,CEIL(1.1) 
    ,FLOOR(1.1)
    ,TRUNC(1.1)
;

SELECT 
     ROUND(-1.5)
    ,CEIL(-1.5)
    ,FLOOR(-1.5)
    ,TRUNC(-1.5)
       
    ,ROUND(-1.1)
    ,CEIL(-1.1) 
    ,FLOOR(-1.1)
    ,TRUNC(-1.1)
;





-- UKOLY ----------------------------------------------------------
-- Zaokrouhlete cislo 1574.14676767676 na dve desetinna mista (pokud si nevite rady -> dokumentace). Použijte funkce ROUND, CEIL, FLOOR, TRUNC.

SELECT 
    ROUND(1574.14676767676, 2)
    , CEIL(1574.14676767676, 2)
    , FLOOR(1574.14676767676, 2)
    , TRUNC(1574.14676767676, 2)
;



------------------------------------------------------------------
-- Další funkce, o kterých je dobré vědět, že existují:
-- ABS()
-- POWER(), SQRT()
-- LOG()
-- RAND()
-- SIN(), COS(), TAN(),

-- Pokud vás víc zajímají -> dokumentace ;-)






---------------------------------------------------------                        
-- DATE FUNCTION
---------------------------------------------------------
--  Manipulace s daty a časem
/*
TO_DATE
DATE_FROM_PARTS
DATEADD
DATEDIFF
EXTRACT
*/


-- Co je snowflake datum?

/*

1. '2021-23-06'
2. '2020/03/05'
3. '2018-05-03'
4. '1.3.2019'


SELECT CAST('' AS DATE);
SELECT ''::DATE;

*/
-- Co s tim, kdyz to snowflake nepozna?
-- https://docs.snowflake.com/en/sql-reference/functions-conversion#date-and-time-formats-in-conversion-functions
-- TO_DATE

SELECT TO_DATE('06.13.2021','MM.DD.YYYY') AS DATE;



-- UKOLY ----------------------------------------------------------

-- Jak bude vypadat funkce pro dalsi data?

SELECT TO_DATE('2020/03/05','YYYY/MM/DD') AS DATE;
SELECT TO_DATE('1.3.2019','DD.MM.YYYY') AS DATE;



------------------------------------------------------------------

-- DATE_FROM_PARTS
SELECT 
    DATE_FROM_PARTS(iyear, imonth, iday)
    ,idate
--  ,*
FROM teror 
LIMIT 100;

-- DATEADD
SELECT DATE_FROM_PARTS(iyear, imonth, iday) AS datum
      ,DATEADD(year,2, datum) as budoucnost        
      ,DATEADD(year,-2, datum) as minulost
//      ,DATEADD(month,-2, datum)
FROM teror
//WHERE datum > DATEADD(year, -4, CURRENT_DATE)
//WHERE DATEADD(year, 2, datum) = DATE_FROM_PARTS(2016, 1, 1)
//WHERE DATEADD(year, 2, datum) = '2016-01-01'
;
-- https://docs.snowflake.com/en/sql-reference/functions-date-time.html#label-supported-date-time-parts

SELECT CURRENT_DATE();

SELECT CURRENT_TIMESTAMP();


-- DATEDIFF

SELECT DATEDIFF(MONTH,'2018-04-21',CURRENT_DATE());

SELECT 
    DATE_FROM_PARTS(iyear, imonth, iday) AS datum
--  ,DATE_FROM_PARTS(2015,1,1)
    ,DATEDIFF(year,datum, DATE_FROM_PARTS(2015,1,1))
FROM teror
WHERE DATEDIFF(year,datum, DATE_FROM_PARTS(2015,1,1)) = -2
;



-- EXTRACT & DATE_PART
SELECT 
     idate AS datum 
    ,EXTRACT(YEAR FROM datum) AS rok --MONTH,DAY,WEEK,HOUR,QUARTER,MINUTE,SECOND
    ,YEAR(datum)
    ,MONTH(datum)
    ,DAY(datum)
    ,DATE_PART(year,datum)
FROM teror;
-- Další zajímavé funkce s datumy:

-- LAST_DAY(): Vrátí poslední den v měsíci pro zadané datum.
-- DATE_TRUNC(): Zkrátí datum na určitý časový úsek, například den, měsíc nebo rok.





-- UKOLY KODIM.CZ ----------------------------------------------------------

// 2.5 // Z IYEAR, IMONTH a IDAY vytvořte sloupeček datum a vypište tohle datum a pak datum o tři měsíce později a klidně i o tři dny a tři měsíce.

SELECT
     DATE_FROM_PARTS(iyear, imonth, iday) AS DATE
    ,DATEADD(MONTH, 3, DATE) AS THREE_MO
    ,DATEADD(DAY, 3, DATE) AS THREE_D
FROM TEROR
;





-------------------------------------------------------------------------------

---------------------------------------------------------
-- LIKE, ILIKE
---------------------------------------------------------
/*
% - 0 az N znaku
_ - jeden znak
*/

-- hledame Bombing/Explosion
SELECT DISTINCT attacktype1_txt
FROM teror 
//WHERE attacktype1_txt LIKE 'bomb%' -- nenajde nic
//WHERE attacktype1_txt LIKE 'Bomb%' -- najde Bombing/Explosion
//WHERE attacktype1_txt ILIKE 'bomb%' -- najde Bombing/Explosion
//WHERE LOWER(attacktype1_txt) LIKE 'bomb%' -- najde Bombing/Explosion
//WHERE attacktype1_txt LIKE '_omb%' -- najde Bombing/Explosion
;


SELECT DISTINCT region_txt
FROM teror 
WHERE region_txt ILIKE '%america%'; -- vybere unikatni nazvy regionu, ktere obsahuji america (kdekoliv a v jakekoliv velikosti)

SELECT DISTINCT gname
FROM teror 
WHERE gname ILIKE 'a%'; -- vybere unikatni nazvy organizaci, ktere zacinaji na a

SELECT DISTINCT gname 
FROM teror 
WHERE gname ILIKE '_a%'; -- vybere unikatni nazvy organizaci, ktere maji v nazvu druhe pismeno a

SELECT city 
FROM teror 
WHERE city like '% % %'; -- vybere vsechny mesta, ktera maji vice jak 2 slova *****

/*
SELECT 'ahoj
dneska 
je 
krásně' AS TEXTIK
WHERE TEXTIK ILIKE '%\n%'
;
*/





-- UKOLY KODIM.CZ ----------------------------------------------------------

// 2.4 // Vypiš všechny organizace, které na jakémkoliv místě v názvu obsahují výraz „anti“ a výraz „extremists“

SELECT DISTINCT GNAME
FROM TEROR
WHERE GNAME ILIKE '%ANTI%' AND GNAME ILIKE '%EXTREMISTS%'
;



------------------------------------------------------------------------------
---------------------------------------------------------     
-- IN, NOT IN
---------------------------------------------------------                     

-- IN, NOT IN
SELECT *
FROM teror
WHERE country_txt <> 'India' AND country_txt <> 'Somalia';

SELECT *
FROM teror
WHERE country_txt NOT IN ('India','Somalia')
//WHERE country_txt IN ('India','Somalia') -- jaka je alternativa?
;



---------------------------------------------------------                        
-- BETWEEN
---------------------------------------------------------    

-- cisla

SELECT * 
FROM teror
WHERE nkillter >= 40 AND nkillter <= 60;

SELECT * 
FROM teror
WHERE nkillter BETWEEN 40 AND 60; -- vcetne **** one condition vs. several above

SELECT DISTINCT iyear
FROM teror 
WHERE iyear BETWEEN 2014 AND 2016; -- vybere unikatni roky mezi roky 2014 a 2016 (vcetne krajnich hodnot)

-- pismena
SELECT city, 
       SUBSTRING(city,1,1) AS prvni_pismeno 
FROM teror 
WHERE prvni_pismeno BETWEEN 'A' AND 'C'; -- vybere mesta, ktera zacinaji na A, B nebo C

-- funguje i na datum
SELECT *
FROM teror
WHERE DATE_FROM_PARTS(iyear, imonth, iday) BETWEEN '2017-11-01' AND '2017-12-01';



------------------------------------------------
-- IS NULL, IS NOT NULL
------------------------------------------------
SELECT weaptype1_txt,
       nkillter 
FROM teror 
WHERE nkillter IS NOT NULL
ORDER BY nkillter DESC;


-- pozor, nekdy null hodnoty nejsou definovane, naucte se rozeznavat NULL hodnotu





-- UKOLY KODIM.CZ ----------------------------------------------------------

// 2.3 // Zobraz sloupečky IYEAR, IMONTH, IDAY, GNAME, CITY, ATTACKTYPE1_TXT, TARGTYPE1_TXT, WEAPTYPE1_TXT, WEAPDETAIL, NKILL, NWOUND a vyber jen útoky, 
//které se staly v Czech Republic v letech 2015, 2016 a 2017. 
-- Všechna data seřaď chronologicky sestupně

SELECT SUMMARY, IYEAR, IMONTH, IDAY, GNAME, CITY, ATTACKTYPE1_TXT, TARGTYPE1_TXT, WEAPTYPE1_TXT, WEAPDETAIL, NKILL, NWOUND
FROM TEROR
WHERE
     COUNTRY_TXT = 'Czech Republic' AND
     IYEAR BETWEEN 2015 AND 2017
ORDER BY IYEAR, IMONTH, IDAY
;





-------------------------------------------------------------------------------
---------------------------------------------------------                        
-- IFNULL
---------------------------------------------------------       

-- IFNULL
SELECT
    nkill
    ,IFNULL(nkill, -99) AS nkill
    ,IFNULL(nkill, 0) AS nkill
FROM teror;

SELECT AVG(nkill)
    ,AVG(IFNULL(nkill,-99))
    ,AVG(IFNULL(nkill,0))
FROM teror;

SELECT AVG(nkill)
    ,AVG(IFNULL(nkill,-99))
    ,AVG(IFNULL(nkill,0))
FROM teror
WHERE nkill IS NOT NULL
//WHERE nkill IS NULL
;

-- Podobná je také funkce COALESCE()




---------------------------------------------------------   
-- CASE WHEN
---------------------------------------------------------   
-- Umožňuje provádět různé akce nebo vrátit různé hodnoty na základě splnění určitých podmínek.

SELECT nkill,
       CASE 
        WHEN NKILL IS NULL THEN 0 
        ELSE NKILL
        END AS nkill_upraveno
       ,IFNULL(nkill,0) AS nkill_upraveno2
FROM TEROR;

SELECT nkill,
       CASE
         WHEN nkill IS NULL THEN 'unknown'
         WHEN nkill > 100 THEN 'over 100 killed'
         WHEN nkill > 0 THEN '1-100 killed'
         WHEN nkill = 0 THEN 'none killed'
         ELSE '00-ERROR'
       END AS upraveny_nkill
FROM teror
ORDER BY upraveny_nkill
;

SELECT DISTINCT region_txt
FROM teror;

SELECT region_txt,
       CASE
         WHEN region_txt ILIKE '%america%' THEN 'Amerika'
         WHEN region_txt ILIKE '%africa%' THEN 'Afrika'
         WHEN region_txt ILIKE '%asia%' THEN 'Asie'
         ELSE region_txt
       END AS continent
FROM teror; -- vytvorime sloupec kontinent podle regionu


-- Podobná funkce IFF()





-- UKOLY KODIM.CZ ----------------------------------------------------------
                        
// 2.6 // Vypiš všechny druhy útoků ATTACKTYPE1_TXT

SELECT DISTINCT ATTACKTYPE1_TXT
FROM TEROR
;

                        
// 2.7 // Vypiš všechny útoky v Německu v roce 2015, vypiš sloupečky IYEAR, IMONTH, IDAY, COUNTRY_TXT, REGION_TXT, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND. Ve sloupečku COUNTRY_TXT bude všude hodnota ‘Německo’

SELECT
    IYEAR
    ,IMONTH
    ,IDAY
    ,CASE
        WHEN COUNTRY_TXT ILIKE 'Germany' THEN 'Německo'
     END AS COUNTRY
    ,REGION_TXT
    ,PROVSTATE
    ,CITY
    ,NKILL
    ,NKILLTER
    ,NWOUND
FROM TEROR
WHERE IYEAR = 2015 AND COUNTRY_TXT = 'Germany'
;


// 2.8 // Kolik událostí se stalo ve třetím a čtvrtém měsíci a počet mrtvých teroristů není NULL?

SELECT COUNT(EVENTID)
FROM TEROR
WHERE IMONTH BETWEEN 3 AND 4 AND NKILLTER IS NOT NULL
;

                    
// 2.9 // Vypiš první 3 města seřazena abecedně kde bylo zabito 30 až 100 teroristů nebo zabito 500 až 1000 lidí. Vypiš i sloupečky nkillter a nkill.

SELECT CITY, NKILL, NKILLTER
FROM TEROR
WHERE NKILLTER BETWEEN 30 AND 100 OR NKILL BETWEEN 500 AND 1000
ORDER BY CITY 
LIMIT 3
;


// 2.10 // Vypiš všechny útoky z roku 2014, ke kterým se přihlásil Islámský stát ('Islamic State of Iraq and the Levant (ISIL)').
/*
Vypiš sloupečky IYEAR, IMONTH, IDAY, GNAME, COUNTRY_TXT, REGION_TXT, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND 
a na konec přidej sloupeček EventImpact, který bude obsahovat:

'Massacre' pro útoky s víc než 1000 obětí
'Bloodbath' pro útoky s 501 - 1000 obětmi
'Carnage' pro ůtoky s 251 - 500 obětmi
'Blodshed' pro útoky se 100 - 250 obětmi
'Slaugter' pro útoky s 1 - 100 obětmi
a ‘N/A’ pro všechny ostatní útoky.
*/

SELECT 
      IYEAR
     ,IMONTH
     ,IDAY
     ,GNAME
     ,COUNTRY_TXT
     ,REGION_TXT
     ,PROVSTATE
     ,CITY
     ,NKILL
     ,NKILLTER
     ,NWOUND
     ,CASE
        WHEN NKILL > 1000 THEN 'Massacre'
        WHEN NKILL > 500 THEN 'Bloodbath'
        WHEN NKILL > 250 THEN 'Carnage'
        WHEN NKILL > 100 THEN 'Bloodshed'
        WHEN NKILL > 1 THEN 'Slaughter'
        ELSE 'N/A'
        END AS EVENT_IMPACT
FROM TEROR
WHERE IYEAR = 2014 AND GNAME ILIKE '%Islamic State of Iraq and the Levant%'
ORDER BY NKILL DESC
;

                        
// 2.11 // Vypiš všechny útoky, které se staly v Německu, Rakousku, Švýcarsku, Francii a Itálii, s alespoň jednou mrtvou osobou. 
/*U Německa, Rakouska, Švýcarska nahraď region_txt za ‘DACH’, u zbytku nech původní region. Vypiš sloupečky IYEAR, IMONTH, IDAY, COUNTRY_TXT, REGION_TXT, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND. Výstup seřaď podle počtu raněných sestupně.*/

SELECT
     IYEAR
     ,IMONTH
     ,IDAY
     ,COUNTRY_TXT   
     ,CASE
        WHEN REGION_TXT = 'Western Europe' AND COUNTRY_TXT IN ('Germany', 'Austria') THEN 'DACH'
        ELSE REGION_TXT
        END AS REGION_TXT     
     ,PROVSTATE
     ,CITY
     ,NKILL
     ,NKILLTER
     ,NWOUND
FROM TEROR
WHERE COUNTRY_TXT IN ('Germany', 'Austria', 'Switzerland', 'France', 'Italy') AND NKILL > 0
ORDER BY NWOUND DESC
;
        
                   
// 2.12 // Vypiš COUNTRY_TXT, CITY, NWOUND a 
/* 
přidej sloupeček vzdalenost_od_albertova obsahující vzdálenost místa útoku z pražské části Albertov v km 
a sloupeček kategorie obsahující ‘Blízko’ pro útoky bližší 2000 km a ‘Daleko’ pro ostatní. 
Vypiš jen útoky s víc než stovkou raněných a seřad je podle vzdálenosti od Albertova.
*/

SELECT
    COUNTRY_TXT AS COUNTRY
    , CITY
    , NWOUND AS WOUNDED
    , ROUND(HAVERSINE(50.0690914, 14.4253433, LATITUDE, LONGITUDE)) AS DIST_FROM_ALBERTOV
    , CASE
        WHEN DIST_FROM_ALBERTOV < 2000 THEN 'NEAR'
        ELSE 'FAR'
        END AS CATEGORY
FROM TEROR
WHERE NWOUND > 100
ORDER BY DIST_FROM_ALBERTOV
;





/*
-------------------------------------------------------------------------------
ÚKOL Z LEKCE 3
-------------------------------------------------------------------------------

// 3.7 // Vypište celkový počet útoků podle druhu zbraně weaptype1_txt, počet mrtvých, mrtvých teroristů, průměrný počet mrtvých, průměrný počet mrtvých teroristů, kolik mrtvých obětí připadá na jednoho mrtvého teroristu a kolik zraněných...

*/

SELECT
    WEAPTYPE1_TXT
    , SUM(NKILL) AS CIVS_KILLED
    , SUM(NKILLTER) TERS_KILLED
    , ROUND(AVG(NKILL)) AS AVG_KILLED
    , ROUND(AVG(NKILLTER)) AS AVG_DEAD_TER
    , CASE
        WHEN SUM(NKILLTER) > 0 THEN ROUND(SUM(NKILL)/SUM(NKILLTER), 2) 
        ELSE NULL
        END AS KILLED_CIV_TO_TER
    , CASE
        WHEN SUM(NKILLTER) > 0 THEN ROUND(SUM(NWOUND)/SUM(NKILLTER), 2)
        ELSE NULL
        END AS WOUNDED_CIV_TO_TER
FROM TEROR
GROUP BY WEAPTYPE1_TXT
;

