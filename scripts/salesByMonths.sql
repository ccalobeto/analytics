CREATE OR REPLACE VIEW vw_monthly_sales_by_sku AS
WITH
-- Aggregate real monthly sales including months with zero sales
-- 1. Aggregate real monthly sales
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
        sum(suma_de_ctd_ped) AS ctd_ped,
        sum(suma_de_ctd_ped_eqv) AS ctd_ped_eqv,
        sum(suma_de_imp_ped) AS imp_ped
    FROM cronologico
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

-- 2. Global min / max month
global_range AS (
    SELECT
        min(m) AS min_m,
        max(m) AS max_m
    FROM monthly_hist
),

-- 3. Global monthly calendar
calendar AS (
    SELECT
        arrayJoin(
            arrayMap(
                x -> addMonths(min_m, x),
                range(dateDiff('month', min_m, max_m) + 1)
            )
        ) AS m
    FROM global_range
),

-- 4. Distinct SKUs
skus AS (
    SELECT DISTINCT
        cod_ovtas,
        flg_abc_xyz,
        dsc_jerarq1,
        dsc_jerarq2,
        dsc_jerarq3,
        material,
        sku_rey
    FROM monthly_hist
)

-- 5. Cross join SKUs × calendar, then left join sales
SELECT
    s.cod_ovtas AS cod_ovtas,
    s.flg_abc_xyz AS flg_abc_xyz,
    s.dsc_jerarq1 AS dsc_jerarq1,
    s.dsc_jerarq2 AS dsc_jerarq2,
    s.dsc_jerarq3 AS dsc_jerarq3,
    s.material AS material,
    s.sku_rey AS sku_rey,
    c.m AS m,
    ifNull(h.ctd_ped, 0) AS ctd_ped,
    ifNull(h.ctd_ped_eqv, 0) AS ctd_ped_eqv,
    ifNull(h.imp_ped, 0) AS imp_ped
FROM skus s
CROSS JOIN calendar c
LEFT JOIN monthly_hist h
    ON  s.cod_ovtas = h.cod_ovtas
    AND s.flg_abc_xyz = h.flg_abc_xyz
    AND s.dsc_jerarq1 = h.dsc_jerarq1
    AND s.dsc_jerarq2 = h.dsc_jerarq2
    AND s.dsc_jerarq3 = h.dsc_jerarq3
    AND s.material = h.material
    AND s.sku_rey = h.sku_rey
    AND c.m = h.m;
