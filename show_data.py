import duckdb

# الاتصال بقاعدة البيانات
con = duckdb.connect('student_performance.duckdb')

# استعلام لعرض أول 10 صفوف من جدول fact_student_performance
try:
    df = con.execute("SELECT * FROM analytics_facts.fact_student_performance LIMIT 10").fetchdf()
    print(df)
except Exception as e:
    print("حدث خطأ:", e)
finally:
    con.close()
