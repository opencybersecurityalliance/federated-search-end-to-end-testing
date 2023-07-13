import argparse
import json
import logging
import os
import sys
import traceback as tb

logging.basicConfig(
    stream=sys.stdout,
    level=logging.INFO,
    format="%(asctime)s %(levelname)s [%(filename)s:" "%(lineno)d]: %(message)s",
)

parser = argparse.ArgumentParser()
parser.add_argument(
    "behave_json_file", help="behave output (in JSON format) input to analysis"
)
parser.add_argument(
    "-a",
    "--analysis",
    type=str,
    default="PassFail",
    help="analysis type PassFail: pass if all features passed, if not, fail",
)

args = parser.parse_args()

behave_json_file = args.behave_json_file
analysis_type = args.analysis
logging.info(
    f"Running with the following args: "
    f"behave results file = {behave_json_file}, "
    f"analysis type = {analysis_type}"
)
test_results = None
try:
    with open(behave_json_file, "r") as fp:
        test_results = json.load(fp)
except:
    logging.error(
        f"Failed to load test results from file "
        f"{behave_json_file}: {tb.print_exc()}"
    )
    sys.exit(-1)
if not test_results:
    logging.error(f"No test results found in {behave_json_file}")
    sys.exit(-1)
if analysis_type == "PassFail":
    pass_fail_result = True
    for feature_result in test_results:
        feature_status = feature_result.get("status", "NotFound")
        if feature_status != "passed":
            logging.info("Testing has FAILED")
            sys.exit(-1)
else:
    logging.warn(f"Analysis of type {analysis_type} not supported yet")
    sys.exit(-1)
