# Stackoverflow Analysis

## Running the dev container

- Prerequisites - Docker must be installed on your local machine
- To launch the dev container, open VS code from the repository, you should be promoted to Re-open in Container

## Running the dbt project

- Firstly add a profile to `dbt/profile/profiles.yml`
- Use the make commands:
    - dbt-build: Runs dbt build against the project
    - dbt-run: Runs dbt run against the project
    - dbt-test: Runs dbt test against the project
