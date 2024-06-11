------------------------------------------------------------------------------------------------------------------
-- TEST PREP ASSIGNMENTS
------------------------------------------------------------------------------------------------------------------

--------------------------------
-- CREATE TABLE, CREATE OR REPLACE TABLE, INSERT INTO TABLE, DELETE FROM TABLE
--------------------------------
-- Přepni se do svého schématu buď myší nebo s použitím USE SCHEMA SCH_CZECHITA_PRIJMENIJ;
-- Použít můžeš příkaz CREATE TABLE, ale (pokud je to tvůr záměr), raději vždy používej CREATE OR REPLACE TABLE
-- Vytvoř si tabulku NAVSTEVY_2022. Chceme, aby měla stejnou strukturu jako již existující tabulka NAVSTEVY.


USE SCHEMA SCH_CZECHITA_HARAMULOVAE;


-- Create empty table

CREATE OR REPLACE TABLE NAVSTEVY_2022
    ( ID INT
    , DATUM TIMESTAMP_NTZ
    , POPIS VARCHAR
    , PACIENT_ID INT
    , POJISTOVNA_ID INT )
;

SELECT * FROM NAVSTEVY_2022;


-- VLOŽENÍ DAT: Zde jsou data pro manuální vložení řádků do tabulky NAVSTEVY_2022. Vlož je.

(1,'2022-03-14 16:20','Preventivní prohlídka, rozhodnuto o trhání 8A',1,1),
(2,'2022-03-15 10:05', NULL,2,2),
(3,'2022-03-15 11:00','Výběr barvy korunky',3,4),
(4,'2022-03-15 17:00','Trhání 8A',1,1),
(5,'2022-06-15 12:30','Instalace nové korunky',3,3),
(6,'2022-08-16 12:45','Nastaly komplikace při trhání 8A, ošetření bolesti',1,2),
(7,'1970-01-01 00:01','Testovací záznam',10,10),
(8,'2022-12-31 17:30','Instalace nové korunky',2,2)
;


-- Insert data into the empty table

INSERT INTO NAVSTEVY_2022
    ( ID
    , DATUM
    , POPIS
    , PACIENT_ID
    , POJISTOVNA_ID )
VALUES
(1,'2022-03-14 16:20','Preventivní prohlídka, rozhodnuto o trhání 8A',1,1),
(2,'2022-03-15 10:05', NULL,2,2),
(3,'2022-03-15 11:00','Výběr barvy korunky',3,4),
(4,'2022-03-15 17:00','Trhání 8A',1,1),
(5,'2022-06-15 12:30','Instalace nové korunky',3,3),
(6,'2022-08-16 12:45','Nastaly komplikace při trhání 8A, ošetření bolesti',1,2),
(7,'1970-01-01 00:01','Testovací záznam',10,10),
(8,'2022-12-31 17:30','Instalace nové korunky',2,2)
;

SELECT * FROM NAVSTEVY_2022;


-- MAZÁNÍ DAT: Smaž řádek z tabulky NAVSTEVY_2022, který na první pohled vypadá jako chybný/testovací.

DELETE FROM NAVSTEVY_2022
WHERE ID = 7
;

SELECT * FROM NAVSTEVY_2022;


-- Spusť tyto dva skripty, ať máme stejná data (přidává časový údaj do sloupce datum)
CREATE OR REPLACE TABLE NAVSTEVY ( 
  ID INT,
  DATUM DATETIME,
  POPIS VARCHAR(2000),
  PACIENT_ID INT,
  POJISTOVNA_ID INT
)
;
INSERT INTO NAVSTEVY (ID, DATUM, POPIS, PACIENT_ID, POJISTOVNA_ID)
  VALUES 
(1,'2023-03-14 16:20','PreventivnÍ prohlídka, rozhodnuto o trhání 8A',1,1),
(2,'2023-03-15 10:05','Ošetření vypadlé plomby',2,2),
(3,'2023-03-15 11:00','Výběr barvy korunky',3,3),
(4,'2023-03-15 12:00','Trhání 8A',1,1),
(5,'2023-03-15 12:30','Instalace nové korunky',3,3),
(6,'2023-03-16 12:45','Nastaly komplikace při trhání 8A, ošetření bolesti',1,2)
;




--------------------------------
-- UNION ALL, UNION, TVORBA ID
--------------------------------

-- UNION ALL spojí tabulky pod sebe, UNION navíc smaže z výsledku duplicitní řádky (stejně jako SELECT DISTINCT)

-- Spoj pod sebe tabulky NAVSTEVY a NAVSTEVY_2022 a vytvoř tak tabulku NAVSTEVY_KOMPLET
-- Sloupec id z tabulek přejmenuj na id_puvodni
-- Vytvoř nový sloupec id, který bude obsahovat primární unikátní klíč pro nově vzniklou tabulku ve formátu např. '2022_1' (rok podtržítko id z původních tabulek)
-- Jako rok pro tabulku NAVSTEVY_2022 použij 2022. Tabulka NAVSTEVY obsahuje pouze události z roku 2023.


-- Create new ID column and concatenate tables
CREATE OR REPLACE TABLE NAVSTEVY_KOMPLET AS
SELECT
      2023 || '_' || ID AS ID 
    , ID AS ID_PUVODNI
    , DATUM
    , POPIS
    , PACIENT_ID
    , POJISTOVNA_ID
FROM NAVSTEVY
UNION ALL 
SELECT
      2022 || '_' || ID AS ID 
    , ID AS ID_PUVODNI
    , DATUM
    , POPIS
    , PACIENT_ID
    , POJISTOVNA_ID
FROM NAVSTEVY_2022
;

SELECT * FROM NAVSTEVY_KOMPLET;




--------------------------------
-- ALTER TABLE, UPDATE TABLE
--------------------------------
-- Můžeme přejmenovat sloupec, přidat a odebrat sloupec, měnit hodnoty atd.
-- Přidej do tabulky NAVSTEVY_KOMPLET nový sloupec "zpracovano", který bude mít defaultní hodnotu 1 a datový typ INTEGER.
-- Proveď kontrolu datových formátů v tabulce.


-- Add a new column with the default value of 1
ALTER TABLE NAVSTEVY_KOMPLET
ADD COLUMN ZPRACOVANO INT DEFAULT 1
;

DESC TABLE NAVSTEVY_KOMPLET;

-- Změň hodnotu ve sloupci zpracovano na 0 pro záznamy, kde pojistovna_id = 3 (Zdravotní pojišťovna datových analitiků)
UPDATE NAVSTEVY_KOMPLET
SET ZPRACOVANO = 0
WHERE 1=1 AND
    POJISTOVNA_ID = 3
;

SELECT * FROM NAVSTEVY_KOMPLET;




--------------------------------
-- WHERE A PODMÍNKY
--------------------------------
-- Vyber všechny sloupce z tabulky NAVSTEVY_KOMPLET.
-- Vyber pouze řádky, které:
 -- Datum je v roce 2022 a pojistovna_id je 3 NEBO datum je v roce 2023 a pojistovna_id je 1 nebo 2
 -- a zároveň kde popis návštěvy obsahuje řetězec '%orun%' nebo '%plom%' (ignoruj velikost písmen)
 -- a zároveň kde zpracovano = 1
 
-- Pokud nevíš, jak napsat některou funkci, vyjledej Googlem například "snowflake year" a nakoukni do dokumentace.

SELECT *
FROM NAVSTEVY_KOMPLET
WHERE 1=1
    AND (YEAR(DATUM) = 2022 AND POJISTOVNA_ID = 3 OR YEAR(DATUM) = 2023 AND POJISTOVNA_ID IN (1, 2))
    AND (POPIS ILIKE '%orun%' OR POPIS ILIKE '%plom%')
    AND ZPRACOVANO = 1
;

SELECT * FROM NAVSTEVY_KOMPLET;




--------------------------------
-- ZÁKLADNÍ (SKALÁRNÍ) FUNKCE, ORDER BY, LIMIT
--------------------------------
-- Vytvoř SELECT, kterým vybereš sloupce id a popis z tabulky NAVSTEVY_KOMPLET.
-- Přidej sloupec, kde vynásobíš 25 s 4. Pojmenuj ho "nasobek" (včetně uvozovek, aby byl mamalými písmeny).
-- Vyber sloupec pojistovna_id, přecastuj ho na VARCHAR(255)
-- Z popis zobraz pouze první slovo
-- Ve sloupci popis nahraď mezery podtržítky
-- K datu přidej vždy dva dny
-- Každému složitějšímu sloupci přidej komentář, ať v budoucnu víš, co dělá
-- Zobraz pouze prvních 10 záznamů, seřazeno dle sloupce datum od nejnovějších

SELECT
      ID
    , POPIS
    , 25*4 AS "nasobek"
    , POJISTOVNA_ID::VARCHAR(255)
    , REPLACE(POPIS, ' ', '_') AS POPIS_UNDERSCORE
    , SPLIT_PART(POPIS, ' ', 1) AS POPIS_FIRST_WORD
    , DATEADD(DAY, 2, DATUM) AS DATUM_PLUS_2D
FROM NAVSTEVY_KOMPLET
ORDER BY DATUM DESC
LIMIT 10
;




--------------------------------
-- CASE WHEN, IFNULL
--------------------------------
-- Z tabulky NAVSTEVY_KOMPLET vyber sloupce id a datum.
-- Pokud ve sloupci popis je hodnota NULL, nahraď ji textem 'Není známo'
-- Přidej sloupec pojistovna_txt, kde:
  -- Pokud je pojistovna_id = 1 vypiš 'Odborová zdravotní pojišťovna'
  -- Pokud je pojistovna_id = 2 vypiš 'Všeobecná zdravotní pojišťovna'
  -- Pokud je pojistovna_id = 3 vypiš 'Zdravotní pojišťovna datových analitiků'
  -- Jinak vypiš 'Jiná'
  
SELECT
      ID
    , DATUM
    , IFNULL(POPIS, 'UNKNOWN') 
    , CASE
        WHEN POJISTOVNA_ID = 1 THEN 'Odborová zdravotní pojišťovna'
        WHEN POJISTOVNA_ID = 2 THEN 'Všeobecná zdravotní pojišťovna'
        WHEN POJISTOVNA_ID = 3 THEN 'Zdravotní pojišťovna datových analytíků'
        ELSE 'OTHER'
    END AS POJISTOVNA_TXT 
FROM NAVSTEVY_KOMPLET
;




--------------------------------
-- COUNT, COUNT DISTINCT
--------------------------------
-- Spočítej, kolik záznamů je v tabulce NAVSTEVY_KOMPLET
-- Spočítej, v kolika různých dnech byla nějaká návštěva
-- Spočítej, kolik různých pojišťoven je v tabulce
-- Spočítej, u kolika záznamů je vyplněný popis (není NULL)

SELECT
      COUNT(*) AS RECORDS_TOTAL
    , COUNT(DISTINCT DATE(DATUM)) AS DIST_DATES
    , COUNT(DISTINCT POJISTOVNA_ID) AS DIST_INSURANCE
    , COUNT(POPIS) AS POPIS_NOT_NULL -- COUNT ignores nulls
FROM NAVSTEVY_KOMPLET
;




--------------------------------
-- AGREGČNÍ FUNKCE: GROUP BY, SUM, MAX
--------------------------------
-- Agreguj data v tabulce NAVSTEVY_KOMPLET na úrovni dní - GROUP BY DATE(datum)
-- Vypiš sloupec s datumem = DATE(datum)
-- Spočítej počet návštěv v daný den
-- Pro každý den vypiš čas nejpozdější návštěvy
-- Sečti pacient_id v daný den (nedává to smysl, jen ukázka sčítání)
-- Celé tohle udělej pouze se záznamy, které jsou zpracované (ZPRACOVANO = 1)

SELECT
      DATE(DATUM) AS DATE
    , COUNT(*) AS TOTAL_VISITS
    , MAX(TIME(DATUM)) AS LATEST_TIME
    , SUM(PACIENT_ID)
--    , ZPRACOVANO
FROM NAVSTEVY_KOMPLET
WHERE 1=1
    AND ZPRACOVANO = 1
GROUP BY DATE --, ZPRACOVANO
;




--------------------------------
-- JOINY
--------------------------------
-- JOIN bingo: https://docs.google.com/spreadsheets/d/1VcuAykkHSMTxr4eme69_7a3mLYFLP5hIWPldKQ0q42A/edit?usp=sharing

-- Chceme vedle sebe spojit tabulku NAVSTEVY_KOMPLET a POJISTOVNY (pojistovna_id = id) a vybrat všechny sloupce.
-- Zajímá nás každá návštěva, chceme ji obohatit o další informace
 --> Použijeme tedy LEFT JOIN, kde tabulka návštěv bude vlevo
 -- Pokud nemáš ve svém schématu tabulku POJISTOVNY, vezmi si ji odsud: COURSES.SCH_CZECHITA.POJISTOVNY

SELECT *
FROM NAVSTEVY_KOMPLET AS N
LEFT JOIN
    COURSES.SCH_CZECHITA.POJISTOVNY AS P
ON N.POJISTOVNA_ID = P.ID
;


-- JOIN + agregace
-- Zajímá nás jmeno pojišťovny z tabulky POJISTOVNY obohacené o následující pole:
  -- Celkový počet návštěv pro pojišťovnu
  -- Datum první a datum poslední návštěvy nějakého pacienta pojišťovny
  -- Celkový počet pacientů, kteří uskutečnili návštěvu na danou pojišťovnu

SELECT
      JMENO
    , COUNT(N.ID) AS TOTAL_VISITS
    , MAX(DATUM) AS LAST_VISIT
    , MIN(DATUM) AS FIRST_VISIT
    , COUNT(DISTINCT PACIENT_ID)
FROM COURSES.SCH_CZECHITA.POJISTOVNY AS P
LEFT JOIN
    NAVSTEVY_KOMPLET AS N
ON N.POJISTOVNA_ID = P.ID
GROUP BY JMENO
;




--------------------------------
-- VNOŘENÝ SELECT, CTE
--------------------------------
-- Pro každého pacienta chceme přidat informaci, kolikrát nás pacient navštívil
-- Chceme tedy vypsat celou tabulku pacienti a pridat sloupec KOLIKRAT
-- Nejdříve si připravíme tabulku s počtem návštěv na pacienta
-- Následně ji spojíme s tabulkou PACITENTI (dáme ji do vnořeného selectu)

SELECT P.*, N.TOTAL_VISITS
FROM COURSES.SCH_CZECHITA.PACIENTI AS P
LEFT JOIN
    (SELECT PACIENT_ID, COUNT(*) AS TOTAL_VISITS
    FROM NAVSTEVY_KOMPLET
    GROUP BY PACIENT_ID) AS N
ON P.ID = N.PACIENT_ID
;

-- Same with CTE

WITH CTE_VISIT_COUNT AS
    ( SELECT PACIENT_ID, COUNT(*) AS TOTAL_VISITS
    FROM NAVSTEVY_KOMPLET
    GROUP BY PACIENT_ID )
SELECT P.*, TOTAL_VISITS
FROM COURSES.SCH_CZECHITA.PACIENTI AS P
LEFT JOIN
    CTE_VISIT_COUNT
ON ID = PACIENT_ID
;




--------------------------------
-- WINDOW FUNKCE
--------------------------------
-- Chceme docílit toho stejného jako v minulém připadě, bez použití agregace a vnořené query
-- Tedy: Pro každého pacienta chceme informaci, kolikrát nás pacient navštívil
-- Dále chceme ke každému pacientovi přidat informaci (sloupec):
   -- posledni_navsteva: Kdy byl pacient na návštěvě naposledy
   -- kolik_pojistoven: Kolik různých zdravotních pojišťoven pacient využil
   -- posledni_popis: Popis u poslední návštěvy pacienta

SELECT
      DISTINCT P.*
    , COUNT(*) OVER (PARTITION BY N.PACIENT_ID) AS TOTAL_VISITS
    , MAX(DATUM) OVER (PARTITION BY N.PACIENT_ID) AS LAST_VISIT
    , COUNT(DISTINCT N.POJISTOVNA_ID) OVER (PARTITION BY N.PACIENT_ID) AS INS_COMP
    , LAST_VALUE(N.POPIS) OVER (PARTITION BY N.PACIENT_ID ORDER BY DATUM) AS LAST_TREATMENT
FROM COURSES.SCH_CZECHITA.PACIENTI AS P
LEFT JOIN
    NAVSTEVY_KOMPLET AS N
ON P.ID = N.PACIENT_ID
;



