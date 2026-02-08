# Technical documentation for Analytics

## Setup the python environment

Activate your conda environment with the following command: `conda activate engineer`

- Then in your conda environment install pandas, openpyxl, pyarrow and fastparquet.

```sh
conda install pandas openpyxl pyarrow fastparquet
```

## Import Excel files

The script converts Excel files to CSV or Parquet format, even when they have multiple sheets and filtered or pivoted data.

- Place the cronologico.xlsx file in the `data/` folder.
- Setup the inputs in the `scripts/xlsx2Parquet.py` file
- Execute the command `python scripts/xlsx2Parquet.py`, the output files (parquet and csv files) will be stored in the `user_files/` folder.

## Import CSV files to ClickHouse

Due to csv parquet files can only be imported to ClickHouse, we will use ClickHouse to ingest the data.

- Create the schema and the `cronologico` table before running the command.
- Use the `scripts/setup.sql` file to create the necessary table into ClickHouse client.

```sh
clickhouse client --multiquery < scripts/setup.sql
```

- Use the `scripts/load.sql` file to load the CSV or Parquet files into ClickHouse client.

```sh
clickhouse client --multiquery < scripts/load.sql
```

- Check the ingested data inside ClickHouse client with this `select count(*) from cronologico` command.

## Forecating
