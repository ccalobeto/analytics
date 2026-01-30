# Technical documentation for Analytics

## Import Excel files

The script converts Excel files to CSV or Parquet format, even when they have multiple sheets and filtered or pivoted data.

- In your conda environment install pandas, openpyxl, pyarrow and fastparquet.

```sh
conda install pandas openpyxl pyarrow fastparquet
```

- Execute the command `python scripts/xlsx2Parquet.py`
