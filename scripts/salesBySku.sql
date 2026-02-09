CREATE OR REPLACE VIEW vw_monthly_sales_by_sku AS
WITH
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

-- 2. Min / Max month per SKU
sku_ranges AS (
    SELECT
        cod_ovtas,
        flg_abc_xyz,
        dsc_jerarq1,
        dsc_jerarq2,
        dsc_jerarq3,
        material,
        sku_rey,
        min(m) AS min_m,
        max(m) AS max_m
    FROM monthly_hist
    GROUP BY
        cod_ovtas,
        flg_abc_xyz,
        dsc_jerarq1,
        dsc_jerarq2,
        dsc_jerarq3,
        material,
        sku_rey
),

-- 3. Generate full month calendar per SKU
calendar AS (
    SELECT
        cod_ovtas,
        flg_abc_xyz,
        dsc_jerarq1,
        dsc_jerarq2,
        dsc_jerarq3,
        material,
        sku_rey,
        arrayJoin(
            arrayMap(
                x -> addMonths(min_m, x),
                range(dateDiff('month', min_m, max_m) + 1)
            )
        ) AS m
    FROM sku_ranges
)

-- 4. Left join real sales to calendar
SELECT
    c.cod_ovtas,
    c.flg_abc_xyz,
    c.dsc_jerarq1,
    c.dsc_jerarq2,
    c.dsc_jerarq3,
    c.material,
    c.sku_rey,
    c.m,
    ifNull(h.ctd_ped, 0) AS ctd_ped,
    ifNull(h.ctd_ped_eqv, 0) AS ctd_ped_eqv,
    ifNull(h.imp_ped, 0) AS imp_ped
FROM calendar c
LEFT JOIN monthly_hist h
    ON  c.cod_ovtas = h.cod_ovtas
    AND c.flg_abc_xyz = h.flg_abc_xyz
    AND c.dsc_jerarq1 = h.dsc_jerarq1
    AND c.dsc_jerarq2 = h.dsc_jerarq2
    AND c.dsc_jerarq3 = h.dsc_jerarq3
    AND c.material = h.material
    AND c.sku_rey = h.sku_rey
    AND c.m = h.m;
