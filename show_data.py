import duckdb


con = duckdb.connect('student_performance.duckdb')

CORE_COLUMNS = [
    'student_id',
    'gender',
    'age',
    'study_hours_per_week',
    'attendance_rate',
    'gpa',
    'major',
    'performance_category',
]

QUERY = f"SELECT {', '.join(CORE_COLUMNS)} FROM staging.raw_students LIMIT 10"

try:
    df = con.execute(QUERY).fetchdf()
    print(df)
except Exception as e:
    print("حدث خطأ عند جلب البيانات:", e)
finally:
    con.close()
