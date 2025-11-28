import streamlit as st
import duckdb
import pandas as pd
import os
from pathlib import Path

@st.cache_data
def load_data():
    # ابدأ بمسار القاعدة بالنسبة لملف dashboard.py (يتعامل مع حالات الاستضافة)
    base_dir = Path(__file__).parent
    db_path = base_dir / "student_performance.duckdb"  # تأكد من اسم الملف الموجود بالـ repo
    csv_path = base_dir / "student_data_with_performance.csv"  # ملف احتياطي إن لم توجد القاعدة

    # Diagnostics info (تُطبع في لوغ Streamlit)
    st.write(f"Looking for DB at: {db_path}")
    st.write(f"Looking for CSV at: {csv_path}")

    # إذا الملف موجود - حاول الاتصال به
    try:
        if db_path.exists():
            con = duckdb.connect(database=str(db_path))
            # عرض جداول القاعدة لتشخيص سريع
            try:
                tables = con.execute("SHOW TABLES").fetchdf()
                st.write("DuckDB tables:", tables)
            except Exception as e:
                st.write("Could not list tables:", repr(e))

            # تحقق من وجود الجداول الأساسية قبل تنفيذ الاستعلام
            required_tables = {"fact_student_performance", "dim_student", "dim_major", "dim_performance_category", "dim_date"}
            existing_tables = set(con.execute("SHOW TABLES").fetchall()[0] if con.execute("SHOW TABLES").fetchall() else [])
            # بدلًا من التعقيد أعلاه سنجرب تنفيذ الاستعلام مباشرة مع اعتراض الأخطاء
            query = """
                 SELECT 
                     f.Student_ID,
                     s.Student_Name,
                     s.Gender,
                     m.Major_Name AS Major,
                     f.GPA,
                     f.Attendance,
                     p.Category_Name AS Performance_Category,
                     d.Semester,
                     d.Academic_Year
                     FROM analytics_facts.fact_student_performance f
                     JOIN analytics_dims.dim_student s ON f.Student_ID = s.Student_ID
                     JOIN analytics_dims.dim_major m ON f.Major_ID = m.Major_ID
                     JOIN analytics_dims.dim_performance_category p ON f.Performance_Category_ID = p.ID
                     JOIN analytics_dims.dim_date d ON f.Date_ID = d.Date_ID;

            """
            df = con.execute(query).fetchdf()
            con.close()
            return df

        # إن لم توجد القاعدة، جرب قراءة CSV احتياطي
        elif csv_path.exists():
            st.warning("DuckDB file not found — loading CSV fallback.")
            df = pd.read_csv(csv_path)
            return df

        else:
            # لا يوجد DB ولا CSV — ارجع خطأ واضح
            raise FileNotFoundError(f"Neither {db_path} nor {csv_path} were found in the app directory.")
    except Exception as e:
        # سجل الخطأ الكامل في لوق Streamlit (ستظهر في صفحة Manage app logs)
        st.error("Data loading failed. See logs for details.")
        # اطبع الاستثناء الكامل لكي يظهر في لوج السحابة
        st.write("Exception details:", repr(e))
        # رمي الخطأ مجدداً إذا أردت أن يتوقف التطبيق (أو يمكن إرجاع df فارغ)
        raise
