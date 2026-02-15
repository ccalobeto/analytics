INSERT INTO analytics.cronologico
SELECT *
FROM file('cronologico.csv', 'csv');
