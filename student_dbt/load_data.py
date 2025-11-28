import duckdb
import pandas as pd

print("=" * 60)
print("Loading Data to DuckDB")
print("=" * 60)

# Connect to DuckDB
conn = duckdb.connect('student_performance.duckdb')
print("✅ Connected to DuckDB")

# Create staging schema
conn.execute("CREATE SCHEMA IF NOT EXISTS staging")
print("✅ Created staging schema")

# Load CSV into DuckDB
print("\n📊 Loading CSV data...")
conn.execute("""
    CREATE OR REPLACE TABLE staging.raw_students AS
    SELECT 
        StudentID::INTEGER as student_id,
        Gender::VARCHAR as gender,
        Age::INTEGER as age,
        StudyHoursPerWeek::INTEGER as study_hours_per_week,
        AttendanceRate::DOUBLE as attendance_rate,
        GPA::DOUBLE as gpa,
        Major::VARCHAR as major,
        PerformanceCategory::VARCHAR as performance_category,
        CURRENT_TIMESTAMP as loaded_at
    FROM read_csv_auto('student_data_with_performance.csv')
""")

# Get count
result = conn.execute("SELECT COUNT(*) FROM staging.raw_students").fetchone()
print(f"✅ Loaded {result[0]} students")

# Show sample
print("\n📋 Sample data:")
sample = conn.execute("SELECT * FROM staging.raw_students LIMIT 5").fetchdf()
print(sample)

conn.close()
print("\n✅ Data loaded successfully!")
print("Next step: Setup DBT project")