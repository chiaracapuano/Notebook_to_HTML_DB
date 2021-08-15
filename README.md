# Shell script to convert Databricks run_id to GitHub webpage

### The script is an adaptation of Databricks "Runs export" feature (https://docs.databricks.com/dev-tools/api/latest/jobs.html#runs-export). This Databricks API feature requires the user to input the run_id, that will then be exported into HTML format. My code, on the other hand, uses the more generic job_id to extract the run_id of the last run, converts this one to HTML and pushes it into a GitHb repo (the code is meant to be used in an IDE properly synced with the GitHub repo where the user wants the web page to live).

###How the code works:

1. connect to the Databricks API of your institution via token. Since I would like this GitHub webpage to be refreshed periodically for a long time period, I set the token expiration to "never" (which is equivalent to an empty string in the Databricks UI for specifying the token time validity).
The code below lists the specific job_id's runs in descending order by start time (all the available settings can be found here: https://docs.databricks.com/dev-tools/api/latest/jobs.html#runs-list. In my case, for example, I want the single, most recent (*offset=0* and *limit=1*) job run (*run_type=JOB_RUN*), that finished running (*completed_only=true*)).


```
export DATABRICKS_TOKEN=<databricks_token>

curl -o runs_lst.json -X GET --header "Authorization: Bearer $DATABRICKS_TOKEN" \
<databricks-instance>/api/2.0/jobs/runs/list?job_id=<job_id> \
&completed_only=true&offset=0&limit=1&run_type=JOB_RUN
```