# Shell script to convert Databricks run_id to GitHub webpage

### The script is an adaptation of Databricks "Runs export" feature (https://docs.databricks.com/dev-tools/api/latest/jobs.html#runs-export). This Databricks API feature requires the user to input the run_id, the notebook run in that specific instance will then be exported into HTML format. My code, on the other hand, uses the more generic job_id to extract the run_id of the last run, converts its notebook  into HTML and pushes it into a GitHb repo (the code is meant to be used in an IDE, properly synced with the GitHub repo where the user wants the web page to live).

Find out what it does at: https://medium.com/@ada.chiara.capuano/convert-databricks-job-run-into-a-github-webpage-12f732514651.
