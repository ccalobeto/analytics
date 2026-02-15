--1.3 ) Get the average sales, standard deviation, coefficient of variation and percentage of zero sales by SKU and family
CREATE OR REPLACE VIEW vw_sku_metrics AS (
SELECT
    cod_ovtas,
    flg_abc_xyz,
    dsc_jerarq1,
    dsc_jerarq2,
    dsc_jerarq3,
    material,
    sku_rey,
    avg(ctd_ped_eqv) AS avg_ped_eqv,
    stddevPop(ctd_ped_eqv) AS std_ped_eqv,
    ifNull(stddevPop(ctd_ped_eqv) / nullIf(avg(ctd_ped_eqv), 0), 0) AS cv_ped_eqv,
    countIf(ctd_ped_eqv = 0) / count() AS pct_zero,
    -- Months since last purchase
    dateDiff(
        'month',
        maxIf(m, ctd_ped_eqv > 0),
        toStartOfMonth(today())
    ) AS months_since_last_purchase
FROM vw_monthly_sales_by_sku
WHERE m < toStartOfMonth(today()) -- only up to last month
GROUP BY cod_ovtas, flg_abc_xyz, dsc_jerarq1, dsc_jerarq2, dsc_jerarq3, material, sku_rey
-- INTO OUTFILE './user_files/sku_metrics.csv'
-- TRUNCATE
-- FORMAT CSVWithNames
);

-- 1.4 categorize SKUs into segments and assign a window of months to look back for forecasting
SELECT
    *,
    quantileExact(0.3)(avg_ped_eqv) AS p30,
    quantileExact(0.7)(avg_ped_eqv) AS p70,
    CASE
    WHEN months_since_last_purchase >= 6 THEN 'DORMANT'

    WHEN pct_zero > 0.4 THEN 'INTERMITENTE'

    WHEN cv_ped_eqv > 1 THEN 'VOLATIL'

    ELSE
        CASE
            WHEN avg_ped_eqv >= p70 THEN 'ALTA'
            WHEN avg_ped_eqv >= p30 THEN 'MEDIA'
            ELSE 'BAJA'
        END
    END AS segment,
    CASE
        WHEN segment = 'ALTA' THEN 3
        WHEN segment = 'MEDIA' THEN 6
        WHEN segment = 'BAJA' THEN 12
        ELSE NULL
    END AS window_months
FROM vw_sku_metrics
ORDER BY 
    cod_ovtas, 
    flg_abc_xyz, 
    dsc_jerarq1, 
    dsc_jerarq2, 
    dsc_jerarq3, 
    material, 
    sku_rey
INTO OUTFILE './user_files/sku_metrics_with_windows.csv'
TRUNCATE
FORMAT CSVWithNames
 