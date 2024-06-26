-- CREATE ONE BIG CLEAN IMPORT/EXPORT TABLE

-- Concatenate imp/exp tables for each year
CREATE TABLE IMPORTS_EXPORTS AS
SELECT *
FROM IMP_EXP_2011
UNION ALL
SELECT *
FROM IMP_EXP_2012
UNION ALL
SELECT *
FROM IMP_EXP_2013
UNION ALL
SELECT *
FROM IMP_EXP_2014
UNION ALL
SELECT *
FROM IMP_EXP_2015
UNION ALL
SELECT *
FROM IMP_EXP_2016
UNION ALL
SELECT *
FROM IMP_EXP_2017
UNION ALL
SELECT *
FROM IMP_EXP_2018
UNION ALL
SELECT *
FROM IMP_EXP_2019
UNION ALL
SELECT *
FROM IMP_EXP_2020
UNION ALL
SELECT *
FROM IMP_EXP_2021
UNION ALL
SELECT *
FROM IMP_EXP_2022
UNION ALL
SELECT *
FROM IMP_EXP_2023
;

-- Change net_wgt data type
ALTER TABLE IMPORTS_EXPORTS
ADD COLUMN NET_WGT_FLOAT FLOAT
;

UPDATE IMPORTS_EXPORTS
SET NET_WGT_FLOAT = TRY_CAST(NULLIF("NetWgt", '') AS FLOAT)
;

-- Drop unnecessary columns from the resulting table
CREATE OR REPLACE TABLE IMPORTS_EXPORTS AS
SELECT
    TO_DATE("RefPeriodId", 'YYYYMMDD') AS YEAR_MO
    , "RefYear" AS YEAR
    , "RefMonth" AS MONTH
    , "ReporterISO" AS REPORTER_CODE
    , "ReporterDesc" AS REPORTER_TXT
    , "FlowDesc" AS FLOW
    , "PartnerISO" AS PARTNER_CODE
    , "PartnerDesc" AS PARTNER_TXT
    , "CmdCode" AS CMD_CODE
    , "CmdDesc" AS CMD_TXT
    , NET_WGT_FLOAT AS NET_WGT
    , "PrimaryValue"::FLOAT AS PRIM_VALUE
FROM IMPORTS_EXPORTS
;



-- CREATE A MEGATABLE FOR IMPORTS, EXPORTS, PRODUCTION AND CONSUMPTION

-- Create aggregated Imports; change YEAR to int
CREATE OR REPLACE TEMPORARY TABLE TEMP_IMPORTS AS
SELECT CAST(YEAR AS INT) AS YEAR, SUM(NET_WGT) AS IMPORT_KG, REPORTER_TXT, FLOW, PARTNER_TXT, CMD_CODE, CMD_TXT
FROM IMPORTS_EXPORTS
WHERE FLOW = 'Import' AND PARTNER_TXT = 'World' AND CMD_CODE = '080810'
GROUP BY YEAR, REPORTER_TXT, FLOW, PARTNER_TXT, CMD_CODE, CMD_TXT
ORDER BY YEAR
;

-- Create aggregated Exports (just year and export)
CREATE OR REPLACE TEMPORARY TABLE TEMP_EXPORTS AS
SELECT CAST(YEAR AS INT) AS YEAR, SUM(NET_WGT) AS EXPORT_KG
FROM IMPORTS_EXPORTS
WHERE FLOW = 'Export' AND PARTNER_TXT = 'World' AND CMD_CODE = '080810'
GROUP BY YEAR
ORDER BY YEAR
;

-- Convert harvest from tons to kg, change data type to number
CREATE OR REPLACE TEMPORARY TABLE TEMP_HARVEST AS
SELECT CAST("Rok" AS INT) AS YEAR, CAST("jablka" AS FLOAT)*1000 AS HARVEST_KG
FROM SKLIZEN_2002_2023_TR
;

-- Add households to harvests
CREATE OR REPLACE TEMPORARY TABLE TEMP_PRIVATE
    (
    YEAR INT,
    HARV_PRIVATE FLOAT
    )
;

INSERT INTO TEMP_PRIVATE (YEAR, HARV_PRIVATE)
VALUES
    (2023, 86060000),
    (2022, 92151000), 
    (2021, 92404000),
    (2020, 94295000),
    (2019, 92645000),
    (2018, 101903000),
    (2017, 101903000),
    (2016, NULL),
    (2015, NULL),
    (2014, NULL),
    (2013, NULL),
    (2012, NULL),
    (2011, NULL)  
;

CREATE OR REPLACE TABLE HARVESTS_TOTAL AS
SELECT H.YEAR, HARVEST_KG AS HARV_ORCH, P.HARV_PRIVATE AS HARV_PRIVATE, P.HARV_PRIVATE/HARVEST_KG AS PERCENT, HARVEST_KG+P.HARV_PRIVATE AS HARV_TOTAL
FROM TEMP_HARVEST AS H
LEFT JOIN TEMP_PRIVATE AS P
    ON H.YEAR = P.YEAR
;

-- Create table with population figures in 2011-2022 (ČSÚ + UN World Population Prospects)
CREATE OR REPLACE TEMPORARY TABLE TEMP_POP
    (
    YEAR INT,
    POPULATION INT
    )
;

INSERT INTO TEMP_POP (YEAR, POPULATION)
VALUES
    (2023, 10759295),
    (2022, 10759525),
    (2021, 10500850),
    (2020, 10700155),
    (2019, 10669324),
    (2018, 10626430),
    (2017, 10589526),
    (2016, 10565284),
    (2015, 10542942),
    (2014, 10524783),
    (2013, 10510719),
    (2012, 10511065),
    (2011, 10496379)  
;

-- Calc total consumption based on population
-- Pick year and apple consumption pp
CREATE OR REPLACE TEMPORARY TABLE TEMP_CONSUMPTION_PP AS
SELECT CAST("rok" AS INT) AS YEAR, CAST("jablka" AS FLOAT) AS CONSUMPTION_PP_KG
FROM SPOTREBA_CR_1948_2022
WHERE "rok" >= 2011
;

-- Multiply consumption pp for each year by population
CREATE OR REPLACE TEMPORARY TABLE TEMP_CONSUMPTION AS
SELECT P.YEAR, CONSUMPTION_PP_KG*POPULATION AS CONSUMPTION_KG, CONSUMPTION_PP_KG, POPULATION
FROM TEMP_POP AS P
LEFT JOIN TEMP_CONSUMPTION_PP AS C
ON C.YEAR = P.YEAR
;

-- Create a mega table for imp, exp, prod, cons
CREATE OR REPLACE TABLE IMP_EXP_PROD_CONS AS
SELECT I.YEAR, IMPORT_KG, EXPORT_KG, HARV_ORCH, HARV_PRIVATE, HARV_TOTAL AS HARVEST_KG, CONSUMPTION_KG, POPULATION, REPORTER_TXT, PARTNER_TXT, CMD_CODE, CMD_TXT
FROM TEMP_IMPORTS AS I
LEFT JOIN TEMP_EXPORTS AS E
    ON I.YEAR = E.YEAR
LEFT JOIN HARVESTS_TOTAL AS H
    ON I.YEAR = H.YEAR
LEFT JOIN TEMP_CONSUMPTION AS C
    ON I.YEAR = C.YEAR
;

