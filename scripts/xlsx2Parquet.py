import pandas as pd
from openpyxl import load_workbook

# Inputs
xlsx_file = "data/FacturacionReyExportacion v2.xlsx"
sheet_name = "Td (3)"   # or sheet index like 0
csv_out = "./data/outputs/output.csv"
parquet_out = "./data/outputs/output.parquet"
skiprows = 6  # Number of rows to skip at the start

# Load workbook in safe mode (avoids pivot cache parsing)
wb = load_workbook(xlsx_file, read_only=True, data_only=True)
ws = wb[sheet_name]

rows = []
for row in ws.iter_rows(values_only=True):
    rows.append(row)

# Build DataFrame
df = pd.DataFrame(rows[7:], columns=rows[6])  # skip first 7 empty rows

# remove the columns when all the values are None
df = df.dropna(axis=1, how='all')
df = df.iloc[:, :-1]  # remove last empty column if exists

# Write outputs
df.to_csv(csv_out, index=False)
df.to_parquet(parquet_out, index=False)
