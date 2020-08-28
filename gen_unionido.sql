USE Testing

IF OBJECT_ID('dbo.UnionIdo', 'U') IS NOT NULL
DROP TABLE dbo.UnionIdo;

CREATE TABLE dbo.UnionIdo (
    id bigint,
    pig date
    )

DECLARE @mindate date = '2019-08-31'
DECLARE @maxdate date = '2020-09-30'

WHILE @mindate <= @maxdate
BEGIN
IF DAY(DATEADD(DAY, 1, @mindate)) = 1
    INSERT dbo.UnionIdo VALUES 
    (
        YEAR(@mindate) * 10000 + MONTH(@mindate) * 100 + DAY(@mindate), 
        @mindate
    )
    SELECT @mindate = DATEADD(DAY, 1, @mindate)
END