# Run all project steps on Windows (PowerShell)
# Usage: ./run_all.ps1

Set-StrictMode -Version Latest

$ErrorActionPreference = 'Stop'

# Change to repo root from script location
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Output "[1/5] Install Python packages..."
python .\student_dbt\setup.py
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to install packages"; exit $LASTEXITCODE }

Write-Output "[2/5] Load CSV data into DuckDB..."
python .\student_dbt\load_data.py
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to load CSV data"; exit $LASTEXITCODE }

Write-Output "[3/5] Run dbt models..."
dbt run --project-dir student_dbt --profiles-dir .
if ($LASTEXITCODE -ne 0) { Write-Error "dbt run failed"; exit $LASTEXITCODE }

Write-Output "[4/5] Run dbt tests..."
dbt test --project-dir student_dbt --profiles-dir .
if ($LASTEXITCODE -ne 0) { Write-Error "dbt test failed"; exit $LASTEXITCODE }

Write-Output "[5/5] Inspect DB and samples..."
python .\inspect_db.py
if ($LASTEXITCODE -ne 0) { Write-Error "inspect_db.py failed"; exit $LASTEXITCODE }

Write-Output "All steps completed successfully!"
