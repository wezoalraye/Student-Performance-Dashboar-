# Student Performance Dashboard (dbt + DuckDB)
This project uses duckdb and dbt (dbt-duckdb adapter) to build an analytics model from CSV data.

## Project Structure (relevant files)
- `student_dbt/` — the dbt project folder (contains models, analyses, macros, etc.)
- `student_dbt/load_data.py` — helper script to load the CSV file into DuckDB
- `student_dbt/setup.py` — installs Python packages required for local development
- `student_performance.duckdb` — (created) the DuckDB file used as the database
- `inspect_db.py` — helper script to inspect tables and print sample rows
- `run_all.ps1` — automation script (PowerShell) that runs setup, load, dbt, tests, inspect

## Requirements
- Python 3.8+ (recommended 3.11)
- dbt (installed via `pip install dbt-duckdb` or run `python student_dbt/setup.py`)
- You can use PowerShell (recommended on Windows) or a bash shell (WSL / Git Bash / Linux / Mac)

## Quick start (Windows / PowerShell)
1. Open PowerShell and navigate to the project root:

```powershell
cd "E:\New folder\Student-Performance-Dashboar-"
```

2. (Optional but recommended) Install dependencies:

```powershell
python student_dbt\setup.py
```

3. Load the CSV data into DuckDB:

> The load script expects `student_data_with_performance.csv` to be in the project root. If your file is named differently or in another folder, update `student_dbt/load_data.py` accordingly.

```powershell
python student_dbt\load_data.py
```

4. Build dbt models (from the `student_dbt` project):

```powershell
dbt run --project-dir student_dbt --profiles-dir .
```

5. Run dbt tests (optional):

```powershell
dbt test --project-dir student_dbt --profiles-dir .
```

6. Inspect the database and samples:

```powershell
python inspect_db.py
```

## Quick start (Unix / Bash)
```bash
cd "E:/New folder/Student-Performance-Dashboar-"
python student_dbt/setup.py
python student_dbt/load_data.py
dbt run --project-dir student_dbt --profiles-dir .
dbt test --project-dir student_dbt --profiles-dir .
python inspect_db.py
```

## Automation (`run_all.ps1`)
Run everything (PowerShell):

```powershell
./run_all.ps1
```

## Notes and Tips
- dbt uses the DuckDB adapter (configured via the project's `profiles.yml`). We recommend always running
	commands with `--profiles-dir .` while working within this repo, to make sure dbt uses the project-level `profiles.yml` file.
- If you prefer to run dbt from the project root without `--project-dir`, you can modify the root `dbt_project.yml` to point `model-paths` to `student_dbt/models`. This repo currently uses the `student_dbt` folder for dbt project files.
- To export the `analytics_facts.fact_student_performance` table to CSV: run `python export_fact.py` (if provided) or use the built-in logic in `inspect_db.py` to copy to a CSV file.

## Troubleshooting
- If the fact table is empty, you probably didn't run the `load_data.py` script or the date dimension didn't include `CURRENT_DATE`. The `dim_date` model was updated to generate a date spine from the earliest `loaded_at` in staging to `CURRENT_DATE`.
- If dbt can't find models, run `dbt ls --project-dir student_dbt --profiles-dir .` to list detected models.

---
If you'd like, I can also convert `run_all.ps1` into a cross-platform script or add a `run_all.sh` for Unix users. Let me know your preferences.