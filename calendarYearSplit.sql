USE Testing

IF OBJECT_ID('tempdb..#t', 'U') IS NOT NULL
DROP TABLE #t;

CREATE TABLE #t (
    PremiumID bigint, 
    PremiumPeriodBegin date, 
    PremiumPeriodEnd date, 
    GWP NUMERIC(20,6)
    )

INSERT INTO #t VALUES
(1, '2017.04.23', '2020.09.03', 501.0), 
(2, '2018.12.05', '2022.03.01', 37.0),
(3, '2020.08.01', '2020.10.30', 876.0), 
(4, '2019.04.02', '2021.06.07', 9004.0)

DECLARE @minyear as INT
DECLARE @maxyear as INT

SELECT 
 @minyear = MIN(YEAR(PremiumPeriodBegin)),
 @maxyear = MAX(YEAR(PremiumPeriodEnd))
FROM #t

IF OBJECT_ID('tempdb..#y', 'U') IS NOT NULL
DROP TABLE #y;

CREATE TABLE #y (
    calYear int
    )


WHILE @minyear  <= @maxyear
    BEGIN
        INSERT INTO #y VALUES (@minyear)        
        SELECT @minyear = @minyear + 1
    END

IF OBJECT_ID('tempdb..#tt', 'U') IS NOT NULL
DROP TABLE tempdb..#tt;

SELECT 
    t.PremiumID, 
    t.PremiumPeriodBegin, 
    t.PremiumPeriodEnd, 
    t.GWP as OriginalPremium, 
    DATEDIFF(DAY, PremiumPeriodBegin, PremiumPeriodEnd) as OriginalDuration, 
    CASE 
        WHEN t.PremiumPeriodBegin >= DATEFROMPARTS(y.calYear, 1, 1) 
        THEN t.PremiumPeriodBegin 
        ELSE DATEFROMPARTS(y.calYear, 1, 1) END AS CalPremiumPeriodBegin,
    CASE 
        WHEN t.PremiumPeriodEnd <= DATEFROMPARTS(y.calYear, 12, 31) 
        THEN t.PremiumPeriodEnd 
        ELSE DATEFROMPARTS(y.calYear, 12, 31) END as CalPremiumPeriodEnd, 
    0 as CalDays, 
    0.0 as CalPremium,  
    y.calYear
INTO #tt
FROM #t t
    INNER JOIN #y y on DATEFROMPARTS(y.calYear, 12,31) > t.PremiumPeriodBegin
        and DATEFROMPARTS(y.calYear, 1, 1) <= t.PremiumPeriodEnd

SELECT 
    PremiumID, 
    PremiumPeriodBegin, 
    PremiumPeriodEnd, 
    OriginalPremium, 
    OriginalDuration , 
    CalPremiumPeriodBegin, 
    CalPremiumPeriodEnd, 
    calYear, 
    DATEDIFF(DAY, CalPremiumPeriodBegin, CalPremiumPeriodEnd) +1 as calDays,
    OriginalPremium / (OriginalDuration + 1) * (DATEDIFF(DAY, CalPremiumPeriodBegin, CalPremiumPeriodEnd) + 1) as CalPremium
FROM #tt