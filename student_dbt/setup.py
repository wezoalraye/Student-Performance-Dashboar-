import subprocess
import sys

print("🚀 Installing required packages...")

packages = ['duckdb', 'pandas', 'dbt-duckdb']

for package in packages:
    print(f"📦 Installing {package}...")
    subprocess.check_call([sys.executable, '-m', 'pip', 'install', package])
    print(f"✅ {package} installed!")

print("\n✅ All packages installed successfully!")
print("Next step: Run 'python load_data.py'")