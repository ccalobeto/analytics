INSERT INTO analytics.ryex
SELECT *
FROM file('output.csv', 'csv');
