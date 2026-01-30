# Technical documentation for Analytics

## Import Excel files

The script converts Excel files to CSV or Parquet format, even when they have multiple sheets and filtered or pivoted data.

- In your conda environment install pandas, openpyxl, pyarrow and fastparquet.

```sh
conda install pandas openpyxl pyarrow fastparquet
```

- Execute the command `python scripts/xlsx2Parquet.py`, the output files will be stored in the `user_files/` folder.

## Import CSV files to ClickHouse

- Use the `scripts/setup.sql` file to create the necessary tables in ClickHouse.

```sh
clickhouse-client --multiquery < scripts/setup.sql
```

- Use the `scripts/load.sql` file to load the CSV or Parquet files into ClickHouse.

```sh
clickhouse-client --multiquery < scripts/load.sql
```

- Check the ingested data inside ClickHouse client with this `select count(*) from ryex`
