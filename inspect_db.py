import duckdb

DB_PATH = 'student_performance.duckdb'

queries = {
    'list_tables': "SELECT table_schema, table_name FROM information_schema.tables ORDER BY table_schema, table_name;",
    'count_staging': "SELECT COUNT(*) AS staging_count FROM staging.raw_students;",
    'sample_staging': "SELECT * FROM staging.raw_students LIMIT 5;",
    'count_facts': "SELECT COUNT(*) AS facts_count FROM analytics_facts.fact_student_performance;",
    'sample_facts': "SELECT * FROM analytics_facts.fact_student_performance LIMIT 5;",
}

print('=' * 80)
print('Connecting to DuckDB at', DB_PATH)
print('=' * 80)

con = duckdb.connect(DB_PATH)

try:
    for label, q in queries.items():
        print('\n' + '-' * 60)
        print('Query:', label)
        print('-' * 60)
        try:
            df = con.execute(q).fetchdf()
            print(df)
        except Exception as e:
            print('  (query failed) ', e)
finally:
    con.close()
    print('\nDone.')
