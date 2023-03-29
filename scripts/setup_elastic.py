import argparse
import base64
import json
import os
import requests
import sys
import time

parser = argparse.ArgumentParser()
parser.add_argument("--secure", 
                    help="verify elastic password setup correctly",
                    action="store_true")
args = parser.parse_args()

# proceed after elasticsearch passes healthcheck
pwd = None
if args.secure:
    with open(os.path.join(os.getenv('HOME'), 'huntingtest', '.es_pwd'), 'r') as f:
        for line in f:
            if line:
                pwd = line.strip() 
    if not pwd:
        print('Failed to setup password, exiting')
        sys.exit(-1)
    with open(os.path.join(os.getenv('HOME'), 'huntingtest', '.es_pwd'), 'w') as f:
        f.write(pwd)
elastic_ready = False
localhost_url = 'https://localhost:9234'
attempts = 1
headers = {}
headers['Authorization'] = b"Basic " + base64.b64encode(f'elastic:{pwd}'.encode('ascii'))
while not elastic_ready and attempts <= 20:
    try:
        res = requests.get(localhost_url, headers=headers, verify=False)
        print(f"{res.status_code}: {json.dumps(res.json(), indent=2)}")
        if args.secure:
            if res.status_code == 200:
                elastic_ready = True
            else:
                print(f"Attempt {attempts} to ping elastic server")
                attempts += 1
                time.sleep(5)
        else:
            elastic_ready = True
    except:
        print(f"Attempt {attempts} to ping elastic server after failing to connect")
        attempts += 1
        time.sleep(5)
if elastic_ready:
    print(f"Elastic server {'secured' if args.secure else 'up'} after {attempts} attempts")
else:
    print(f"Gave up after {attempts} attempts")
    sys.exit(-1)