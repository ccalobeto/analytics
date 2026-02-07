CREATE DATABASE IF NOT EXISTS analytics;
USE analytics;

CREATE TABLE IF NOT EXISTS cronologico
(
    -- use Nullable for Excel-origin data
    dsc_clasif_cl	                    Nullable(String),
    dsc_gpo_cli1	                    Nullable(String),
    sku_rey	                            Nullable(String),
    cod_ovtas	                        Nullable(String),
    fch_anomes_ped	                    Nullable(Int32),
    num_ped	                            Nullable(String),
    flg_abc_xyz	                        Nullable(String),
    dsc_jerarq3	                        Nullable(String),
    dsc_jerarq2	                        Nullable(String),
    dsc_jerarq1	                        Nullable(String),
    material	                        Nullable(String),
    cliente	                            Nullable(String),
    orden_de_compra	                    Nullable(String),
    fch_ped	                            Nullable(DateTime64(9)),
    cod_mat	                            Nullable(String),
    fch_entrg	                        Nullable(DateTime64(9)),
    dsc_mat	                            Nullable(String),
    medida	                            Nullable(String),
    color	                            Nullable(String),
    cod_color	                        Nullable(String),
    dsc_acabado	                        Nullable(String),
    dsc_marca	                        Nullable(String),
    puller	                            Nullable(String),
    up	                                Nullable(String),
    suma_de_num_dias_fchfac_vs_fchped	Nullable(Int32),
    suma_de_num_dias_fchfac_vs_fchent	Nullable(Int32),
    suma_de_ctd_ped_eqv	                Nullable(Float64),
    suma_de_ctd_ped	                    Nullable(Float64),
    suma_de_ctd_pend	                Nullable(Float64),
    suma_de_imp_pend	                Nullable(Float64),
    suma_de_imp_ped	                    Nullable(Float64),
    suma_de_ctd_pend_eqv	            Nullable(Float64),
)
ENGINE = MergeTree
ORDER BY tuple();
