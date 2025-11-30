import duckdb
import pandas as pd

def connect_db():
    """Connect to DuckDB"""
    return duckdb.connect('student_performance.duckdb')

def top_students_by_gpa(conn, limit=10):
    """Get top students by GPA"""
    query = f"""
        SELECT 
            f.student_id,
            s.gender,
            s.age,
            s.age_group,
            m.major_name,
            m.department,
            f.gpa_score,
            f.attendance_rate,
            f.study_hours_per_week,
            f.composite_performance_score
        FROM analytics_facts.fact_student_performance f
        JOIN analytics_dimensions.dim_student s ON f.student_key = s.student_key
        JOIN analytics_dimensions.dim_major m ON f.major_key = m.major_key
        ORDER BY f.gpa_score DESC
        LIMIT {limit}
    """
    return conn.execute(query).fetchdf()

def top_by_major(conn):
    """Get top student in each major"""
    query = """
        WITH ranked AS (
            SELECT 
                f.student_id,
                m.major_name,
                f.gpa_score,
                f.attendance_rate,
                ROW_NUMBER() OVER (PARTITION BY m.major_name ORDER BY f.gpa_score DESC) as rank
            FROM analytics_facts.fact_student_performance f
            JOIN analytics_dimensions.dim_major m ON f.major_key = m.major_key
        )
        SELECT 
            major_name,
            student_id,
            gpa_score,
            attendance_rate
        FROM ranked
        WHERE rank = 1
        ORDER BY gpa_score DESC
    """
    return conn.execute(query).fetchdf()

def high_achievers(conn):
    """Get all high achievers"""
    query = """
        SELECT 
            f.student_id,
            s.gender,
            m.major_name,
            f.gpa_score,
            f.attendance_rate
        FROM analytics_facts.fact_student_performance f
        JOIN analytics_dimensions.dim_student s ON f.student_key = s.student_key
        JOIN analytics_dimensions.dim_major m ON f.major_key = m.major_key
        WHERE f.is_high_achiever = 1
        ORDER BY f.gpa_score DESC
    """
    return conn.execute(query).fetchdf()

def main():
    print("=" * 80)
    print("STUDENT PERFORMANCE ANALYSIS")
    print("=" * 80)
    
    conn = connect_db()
    
    # Top 10 by GPA
    print("\n📊 TOP 10 STUDENTS BY GPA:")
    print("-" * 80)
    df_top = top_students_by_gpa(conn, 10)
    print(df_top.to_string(index=False))
    
    # Top by Major
    print("\n\n🎓 TOP STUDENT IN EACH MAJOR:")
    print("-" * 80)
    df_major = top_by_major(conn)
    print(df_major.to_string(index=False))
    
    # High Achievers
    print("\n\n🏆 ALL HIGH ACHIEVERS (GPA >= 3.5 & Attendance >= 85%):")
    print("-" * 80)
    df_achievers = high_achievers(conn)
    print(f"Total High Achievers: {len(df_achievers)}")
    if len(df_achievers) > 0:
        print(df_achievers.head(10).to_string(index=False))
    else:
        print("No high achievers found.")
    
    # Statistics
    print("\n\n📈 STATISTICS:")
    print("-" * 80)
    print(f"Average GPA of Top 10: {df_top['gpa_score'].mean():.2f}")
    print(f"Average Attendance of Top 10: {df_top['attendance_rate'].mean():.2f}%")
    print(f"Average Study Hours of Top 10: {df_top['study_hours_per_week'].mean():.1f} hrs/week")
    
    # Gender breakdown
    print("\n\n👥 GENDER BREAKDOWN OF TOP 10:")
    print("-" * 80)
    print(df_top['gender'].value_counts())
    
    # Major breakdown
    print("\n\n🎓 MAJOR BREAKDOWN OF TOP 10:")
    print("-" * 80)
    print(df_top['major_name'].value_counts())
    
    conn.close()
    
    print("\n" + "=" * 80)
    print("✅ Analysis Complete!")
    print("=" * 80)

if __name__ == "__main__":
    main()