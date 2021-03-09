BEGIN
BEGIN TRY

    IF OBJECT_ID('tempdb..#t', 'U') IS NOT NULL
    DROP TABLE #t;

    CREATE TABLE #t
    (
        ID bigint,
        ReferenceDate date,
        Amount NUMERIC(20,6)
    )


END TRY
BEGIN CATCH

END CATCH

END