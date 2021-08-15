# Shell script to convert Databricks run_id to GitHub webpage

### The script is an adaptation of Databricks "Runs export" feature (https://docs.databricks.com/dev-tools/api/latest/jobs.html#runs-export). This Databricks API feature requires the user to input the run_id, the notebook run in that specific instance will then be exported into HTML format. My code, on the other hand, uses the more generic job_id to extract the run_id of the last run, converts its notebook  into HTML and pushes it into a GitHb repo (the code is meant to be used in an IDE, properly synced with the GitHub repo where the user wants the web page to live).

### How the code works:

1. connect to the Databricks API of your institution via token. Since I would like this GitHub webpage to be refreshed periodically for a long time period, I set the token expiration to "never" (which is equivalent to an empty string in the Databricks UI for specifying the token time validity).
The code below lists the specific job_id's runs in descending order by start time (all the available settings can be found here: https://docs.databricks.com/dev-tools/api/latest/jobs.html#runs-list. In my case, for example, I want the single, most recent (*offset=0* and *limit=1*) job run (*run_type=JOB_RUN*), that finished running (*completed_only=true*)).
The output is in json format, that I save in the file runs_lst.json.

```
export DATABRICKS_TOKEN=<databricks_token>

curl -o runs_lst.json -X GET --header "Authorization: Bearer $DATABRICKS_TOKEN" \
<databricks-instance>/api/2.0/jobs/runs/list?job_id=<job_id> \
&completed_only=true&offset=0&limit=1&run_type=JOB_RUN
```

2. Parse runs_lst.json to extract the run_id of interest and save it in the local variable run_id_v:
```
run_id_v=$(python run_id_parse.py)
```

3. use the run_id_v variable defined in the step above to export the notebook run in the instance into HTML format. The Python code in parse.py extracts the HTML notebook from the JSON response, and is offered by Databricks at: https://docs.databricks.com/_static/examples/extract.py.


```
curl -o output.json -X GET --header "Authorization: Bearer $DATABRICKS_TOKEN" \
<databricks-instance>/api/2.0/jobs/runs/export?run_id=$run_id_v

python parse.py --input_file ./output.json --output_dir .
```

4. The extracted notebook is going to have the same name as the notebook run in Databricks. In my case, the notebook always has the same name, however the code can be easily generalized by extracting the notebook name as well when parsing the json output of the code in step 1.
The HTML notebook name is then saved as index.html.
```
mv <notebook_name>.html index.html

git add . && git commit -m "last update" && git push
```

5. Finally, push the changes.
```
git add . && git commit -m "last update" && git push
```

### CAVEATS
This code will only work if run in an IDE, synchronized with the GitHb repo you would like  your page to be displayed at. Also, all the files are going to be written in this same repo, however, the only file you really need is index.html. In my case, I have all the files, but the index, in the gitignore (the Python scripts to parse the json response, and the json response itself).