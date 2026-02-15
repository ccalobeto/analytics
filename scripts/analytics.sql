-- pedidos por año y mes
SELECT
    fch_ano_dcmto,
    fch_mes_dcmto,
    count(fch_ano_dcmto) AS count
FROM ryex
GROUP BY
    fch_ano_dcmto,
    fch_mes_dcmto
ORDER BY fch_mes_dcmto ASC

-- pedidos por año y cliente
SELECT
    fch_ano_dcmto,
    dsc_cli,
    dsc_pais_destino,
    count(fch_ano_dcmto) AS count
FROM ryex
GROUP BY
    fch_ano_dcmto,
    dsc_cli,
    dsc_pais_destino
ORDER BY count DESC

-- notas de credito por año y cliente
SELECT
    fch_ano_dcmto,
    dsc_cli,
    count(fch_ano_dcmto) AS count
FROM ryex
WHERE dsc_cl_dcmto = 'NOTA DE CRÉDITO'
GROUP BY
    fch_ano_dcmto,
    dsc_cli
ORDER BY count DESC

-- pedidos por año y país destino
SELECT
    fch_ano_dcmto,
    dsc_pais_destino,
    count(fch_ano_dcmto) AS count,
    round((100 * count) / sum(count) OVER (), 2) AS participation_pct
FROM ryex
GROUP BY
    fch_ano_dcmto,
    dsc_pais_destino
ORDER BY count DESC

-- participación de pedidos por año y país destino
SELECT
    fch_ano_dcmto,
    dsc_pais_destino,
    count(fch_ano_dcmto) AS count,
    round((100 * count) / sum(count) OVER (), 2) AS participation_pct
FROM ryex
GROUP BY
    fch_ano_dcmto,
    dsc_pais_destino
ORDER BY count DESC

-- Top 5 grupo de artículo por año, el 80% de los pedidos
WITH ranked AS (
    SELECT
        dsc_pais_destino,
        fch_ano_dcmto,
        intDiv(fch_mes_dcmto - 1, 3) + 1 AS fch_qua_dcmto,
        dsc_jerarquia,
        grupo_articulo,
        count() AS cnt,
        round(
            100 * count() / sum(count()) OVER (PARTITION BY dsc_pais_destino),
            2
        ) AS participation_pct,
        row_number() OVER (
            PARTITION BY dsc_pais_destino
            ORDER BY count() DESC
        ) AS rn
    FROM ryex
    GROUP BY
        dsc_pais_destino,
        fch_ano_dcmto,
        fch_qua_dcmto,
        dsc_jerarquia,
        grupo_articulo
)

SELECT
    dsc_pais_destino,
    fch_ano_dcmto,
    fch_qua_dcmto,
    dsc_jerarquia,
    grupo_articulo,
    cnt AS count,
    participation_pct
FROM ranked
--WHERE rn <= 5
ORDER BY
    dsc_pais_destino,
    fch_ano_dcmto ASC,
    fch_qua_dcmto ASC,
    count DESC
INTO OUTFILE './user_files/top_5_grupo_articulo_por_ano.csv'
TRUNCATE
FORMAT CSVWithNames;
