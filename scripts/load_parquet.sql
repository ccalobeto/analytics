INSERT INTO analytics.ryex
SELECT *
FROM file('output.parquet', 'parquet');