
-- 1. Create a view of monthly sales data by material
CREATE OR REPLACE VIEW vw_monthly_hist_by_material AS
WITH monthly_hist AS (
  SELECT
    cod_ovtas,
    flg_abc_xyz,
    dsc_jerarq1,
    dsc_jerarq2,
    dsc_jerarq3,
    material,
    toStartOfMonth(fch_ped) AS startOfMonth,
    sum(suma_de_ctd_ped) AS suma_de_ctd_ped,
    sum(suma_de_ctd_ped_eqv) AS suma_de_ctd_ped_eqv,
    sum(suma_de_imp_ped) AS suma_de_imp_ped
  FROM cronologico
  GROUP BY cod_ovtas,flg_abc_xyz, dsc_jerarq1, dsc_jerarq2, dsc_jerarq3, material, startOfMonth
)

SELECT * FROM monthly_hist
ORDER BY cod_ovtas,flg_abc_xyz, dsc_jerarq1, dsc_jerarq2, dsc_jerarq3, material, startOfMonth
-- INTO OUTFILE './user_files/monthly_hist_by_material.csv'
-- TRUNCATE
-- FORMAT CSVWithNames;

-- 2. Create Moving Average to forecast the next 12 months of sales data by material
WITH
  -- 2.1) Monthly history from daily
  monthly_hist AS (
    SELECT 
      cod_ovtas,
      flg_abc_xyz,
      dsc_jerarq1,
      dsc_jerarq2,
      dsc_jerarq3,
      material,
    toStartOfMonth(fch_ped) AS m,
    sum(suma_de_ctd_ped_eqv) AS y_m
    FROM cronologico
    -- only up to a completed month
    WHERE toStartOfMonth(fch_ped) < toStartOfMonth(today()) 
    GROUP BY 
      cod_ovtas,
      flg_abc_xyz, 
      dsc_jerarq1, 
      dsc_jerarq2, 
      dsc_jerarq3, 
      material,
      m
  ),
  -- 2.2) 12-month moving average
  moving_avg AS (
    SELECT
      cod_ovtas,
      flg_abc_xyz,
      dsc_jerarq1,
      dsc_jerarq2,
      dsc_jerarq3,
      material,
      m,
      AVG(y_m) OVER (
        PARTITION BY cod_ovtas, flg_abc_xyz, dsc_jerarq1, dsc_jerarq2, dsc_jerarq3, material
        ORDER BY m
        ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
      ) AS ma12
    FROM monthly_hist
  ),
  -- 2.3) Latest month & its MA12
  last_ma AS (
    SELECT 
      cod_ovtas,
      flg_abc_xyz, 
      dsc_jerarq1, 
      dsc_jerarq2,
      dsc_jerarq3, 
      material, 
      argMax(m, m) AS last_m, -- same as max(m)
      argMax(ma12, m) AS last_ma12 -- MA12 at latest month
    FROM moving_avg
    GROUP BY 
      cod_ovtas,
      flg_abc_xyz, 
      dsc_jerarq1, 
      dsc_jerarq2, 
      dsc_jerarq3, 
      material
  ),
  -- 2.4) Create the keys for the forecast (distinct combinations of dimensions)
    keys AS (    
    SELECT DISTINCT
      cod_ovtas,
      flg_abc_xyz,
      dsc_jerarq1,
      dsc_jerarq2,
      dsc_jerarq3,
      material
    FROM cronologico
    ),
  -- 2.5) Forecast horizon: next 3 calendar months from today()
  future AS (
    SELECT
      k.cod_ovtas,
      k.flg_abc_xyz, 
      k.dsc_jerarq1, 
      k.dsc_jerarq2, 
      k.dsc_jerarq3, 
      k.material, 
      addMonths(toStartOfMonth(today()), off) AS m
    FROM keys k
    ARRAY JOIN range(0,4) AS off
  )

-- 2.6) Final forecast exported to CSV
SELECT
  f.cod_ovtas,
  f.flg_abc_xyz,
  f.dsc_jerarq1,
  f.dsc_jerarq2,
  f.dsc_jerarq3,
  f.material,
  f.m,
  l.last_ma12 AS y_hat_ma12
FROM future f
LEFT JOIN last_ma AS l 
USING (cod_ovtas, flg_abc_xyz, dsc_jerarq1, dsc_jerarq2, dsc_jerarq3, material)
ORDER BY 
  cod_ovtas,
  flg_abc_xyz, 
  dsc_jerarq1, 
  dsc_jerarq2, 
  dsc_jerarq3, 
  material, 
  m
INTO OUTFILE './user_files/forecast_by_material.csv'
TRUNCATE
FORMAT CSVWithNames;

-- 3. Create Moving Average to forecast the next 12 months of sales data by SKU
WITH  
  -- 3.1) Monthly history from daily
  monthly_hist AS (
    SELECT 
      cod_ovtas,
      flg_abc_xyz,
      dsc_jerarq1,
      dsc_jerarq2,
      dsc_jerarq3,
      material,
      sku_rey,
    toStartOfMonth(fch_ped) AS m,
    sum(suma_de_ctd_ped_eqv) AS y_m
    FROM cronologico
    -- only up to last month
    WHERE toStartOfMonth(fch_ped) < toStartOfMonth(today()) 
    GROUP BY 
      cod_ovtas,
      flg_abc_xyz, 
      dsc_jerarq1, 
      dsc_jerarq2, 
      dsc_jerarq3, 
      material,
      sku_rey,
      m
  ),
  -- 3.2) 12-month moving average
  moving_avg AS (
    SELECT
      cod_ovtas,
      flg_abc_xyz,
      dsc_jerarq1,
      dsc_jerarq2,
      dsc_jerarq3,
      material,
      sku_rey,
      m,
      AVG(y_m) OVER (
        PARTITION BY cod_ovtas, flg_abc_xyz, dsc_jerarq1, dsc_jerarq2, dsc_jerarq3, material, sku_rey
        ORDER BY m
        ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
      ) AS ma12
    FROM monthly_hist
  ),
  -- 3.3) Latest month & its MA12
  last_ma AS (
    SELECT 
      cod_ovtas,
      flg_abc_xyz, 
      dsc_jerarq1, 
      dsc_jerarq2,
      dsc_jerarq3, 
      material,
      sku_rey,
      argMax(m, m) AS last_m, -- same as max(m)
      argMax(ma12, m) AS last_ma12 -- MA12 at latest month
    FROM moving_avg
    GROUP BY 
      cod_ovtas,
      flg_abc_xyz, 
      dsc_jerarq1, 
      dsc_jerarq2, 
      dsc_jerarq3, 
      material,
      sku_rey
  ),
  -- 3.4) Create the keys for the forecast
  keys AS (    
    SELECT DISTINCT
      cod_ovtas,
      flg_abc_xyz,
      dsc_jerarq1,
      dsc_jerarq2,
      dsc_jerarq3,
      material,
      sku_rey
    FROM cronologico
    ),
  -- 3.5) Forecast horizon: next 3 calendar months from today()
  future AS (
    SELECT
      k.cod_ovtas,
      k.flg_abc_xyz, 
      k.dsc_jerarq1, 
      k.dsc_jerarq2, 
      k.dsc_jerarq3, 
      k.material,
      k.sku_rey,
      addMonths(toStartOfMonth(today()), off) AS m
    FROM keys k
    ARRAY JOIN range(0,4) AS off
  )

-- 3.6) Final forecast exported to CSV
SELECT
  f.cod_ovtas,
  f.flg_abc_xyz,
  f.dsc_jerarq1,
  f.dsc_jerarq2,
  f.dsc_jerarq3,
  f.material,
  f.sku_rey,
  f.m,
  l.last_ma12 AS y_hat_ma12
FROM future f
LEFT JOIN last_ma AS l 
USING (cod_ovtas, flg_abc_xyz, dsc_jerarq1, dsc_jerarq2, dsc_jerarq3, material, sku_rey)
ORDER BY 
  cod_ovtas,
  flg_abc_xyz, 
  dsc_jerarq1, 
  dsc_jerarq2, 
  dsc_jerarq3, 
  material, 
  sku_rey,
  m
INTO OUTFILE './user_files/forecast_by_sku.csv'
TRUNCATE
FORMAT CSVWithNames;