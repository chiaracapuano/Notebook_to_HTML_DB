import json

def extract_run_id():
    with open('./runs_lst.json') as f:
        data = json.load(f)
    return data['runs'][0]['run_id']


if __name__ == "__main__":
    print(extract_run_id())