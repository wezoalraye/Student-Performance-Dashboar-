import streamlit as st
import duckdb
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

st.set_page_config(page_title="Student Performance Dashboard", layout="wide")


# Load Data From DuckDB Using Star Schema Joins
@st.cache_data
def load_data():
    con = duckdb.connect("student_performance.duckdb")  # اسم قاعدة البيانات

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
    FROM fact_student_performance f
    JOIN dim_student s ON f.Student_ID = s.Student_ID
    JOIN dim_major m ON f.Major_ID = m.Major_ID
    JOIN dim_performance_category p ON f.Performance_Category_ID = p.ID
    JOIN dim_date d ON f.Date_ID = d.Date_ID
    """
    
    df = con.execute(query).fetchdf()
    con.close()
    return df


df = load_data()

# Dashboard Title
st.title("📊 Student Performance Dashboard (DuckDB + DBT Powered)")


# Filters Section
col1, col2, col3 = st.columns(3)
gender_filter = col1.selectbox("Filter by Gender", ["All"] + sorted(df["Gender"].unique().tolist()))
major_filter = col2.selectbox("Filter by Major", ["All"] + sorted(df["Major"].unique().tolist()))
year_filter = col3.selectbox("Academic Year", ["All"] + sorted(df["Academic_Year"].unique().tolist()))

filtered_df = df.copy()

if gender_filter != "All":
    filtered_df = filtered_df[filtered_df["Gender"] == gender_filter]

if major_filter != "All":
    filtered_df = filtered_df[filtered_df["Major"] == major_filter]

if year_filter != "All":
    filtered_df = filtered_df[filtered_df["Academic_Year"] == year_filter]


# Dataset Preview
st.subheader("📌 Dataset Preview")
st.dataframe(filtered_df.head())

# GPA Distribution
st.subheader("📈 GPA Distribution")
fig, ax = plt.subplots()
sns.histplot(filtered_df["GPA"], kde=True, ax=ax)
st.pyplot(fig)

# GPA by Major
st.subheader("🎓 Average GPA by Major")
fig2, ax2 = plt.subplots(figsize=(8,4))
filtered_df.groupby("Major")["GPA"].mean().sort_values().plot(kind="bar", ax=ax2)
st.pyplot(fig2)

# Attendance vs GPA
st.subheader("📅 Attendance vs GPA")
fig3, ax3 = plt.subplots(figsize=(8,4))
sns.scatterplot(data=filtered_df, x="Attendance", y="GPA", hue="Performance_Category", ax=ax3)
st.pyplot(fig3)

# Performance Category Pie Chart
st.subheader("🏅 Performance Category Distribution")
fig4, ax4 = plt.subplots()
filtered_df["Performance_Category"].value_counts().plot(kind="pie", autopct="%1.1f%%", ax=ax4)
ax4.set_ylabel("")
st.pyplot(fig4)

st.success("Dashboard Loaded Successfully 🚀 (Data Warehouse & Joins Enabled)")
