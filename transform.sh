#!/bin/bash

export DATABRICKS_TOKEN={***}

curl -o runs_lst.json -X GET --header "Authorization: Bearer $DATABRICKS_TOKEN" \
https://institution.cloud.databricks.com/api/2.0/jobs/runs/list?job_id={***}&active_only=false&offset=1&limit=1&run_type=JOB_RUN

run_id_v=$(python run_id_parse.py)

echo $run_id_v

curl -o output.json -X GET --header "Authorization: Bearer $DATABRICKS_TOKEN" \
https://institution.cloud.databricks.com/api/2.0/jobs/runs/export?run_id=$run_id_v

python parse.py --input_file ./output.json --output_dir .

mv {notebook_name}.html index.html

git add . && git commit -m "last update" && git push