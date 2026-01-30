CREATE DATABASE IF NOT EXISTS analytics;
USE analytics;

CREATE TABLE IF NOT EXISTS ryex
(
    -- use Nullable for Excel-origin data
    fch_ano_dcmto          Nullable(Int32),
    fch_mes_dcmto    	    Nullable(Int32),
    dsc_cli        	    Nullable(String),
    dsc_cl_dcmto    	    Nullable(String),
    dsc_pais_destino	    Nullable(String),
    dsc_jerarquia    	    Nullable(String),
    grupo_articulo   	    Nullable(String),
    dsc_material    	    Nullable(String),
    cod_material    	    Nullable(String),
    dsc_acabado     	    Nullable(String),
    cod_color       	    Nullable(String),
    dsc_color       	    Nullable(String),
    dsc_puller      	    Nullable(String),
    dsc_medida      	    Nullable(String),
    dsc_marca       	    Nullable(String),
    num_dcmto       	    Nullable(String),
    num_dcmto_fisico	    Nullable(String),
    num_dcmto_vta   	    Nullable(String),
    num_oc_cli      	    Nullable(String),
    num_dcmto_pos   	    Nullable(String),
    num_pos_dcmto_vta	    Nullable(String),
    num_doc_modelo  	    Nullable(String),
    up              	    Nullable(String),
    cod_marca       	    Nullable(String),
    num_medida      	    Nullable(String),
    cod_acabado     	    Nullable(String),
    cod_puller      	    Nullable(String),
    fch_dcmto       	    Nullable(DateTime64(9)),
    dsc_vendedor_cli	    Nullable(String),
    dsc_vendedor_dcmto	    Nullable(String),
    suma_de_imp_vvta_dol	Nullable(Float64),
    suma_de_ctd_dcmto	    Nullable(Float64),
    suma_de_ctd_dcmto_eqv	Nullable(Float64),
    cuenta_de_num_dcmto	    Nullable(Float64)
)
ENGINE = MergeTree
ORDER BY tuple();
