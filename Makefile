dbt-build:
	dbt build --profiles-dir dbt/profile/ --project-dir dbt/project/
dbt-run:
	dbt run --profiles-dir dbt/profile/ --project-dir dbt/project/
dbt-test:
	dbt test --profiles-dir dbt/profile/ --project-dir dbt/project/
