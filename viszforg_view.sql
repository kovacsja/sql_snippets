USE Testing;

IF OBJECT_ID('tempdb..#dat', 'U') IS NOT NULL
DROP TABLE #dat;

SELECT 
    u.id, 
    u.pig, 
    1 AS factor,
    lag(pig, 1) OVER (ORDER BY u.pig DESC) AS rpig, 
    -1 AS rfactor
INTO #dat
FROM dbo.UnionIdo u


SELECT 
    dd1.ReferenceDate, 
    dd1.DefferenceType, 
    CASE WHEN dd1.DefferenceType = 0 THEN dd1.Amount ELSE -dd1.Amount END * d.factor AS DefferedAmount
FROM 
    #dat d
    INNER JOIN dbo.Deffered_Data dd1 ON d.pig = dd1.ReferenceDate

UNION ALL

SELECT 
    d.rpig, 
    dd1.DefferenceType, 
    CASE WHEN dd1.DefferenceType = 0 THEN dd1.Amount ELSE -dd1.Amount END * d.rfactor AS DefferedAmount
FROM 
    #dat d
    JOIN dbo.Deffered_Data dd1 ON d.pig = dd1.ReferenceDate

DROP TABLE #dat