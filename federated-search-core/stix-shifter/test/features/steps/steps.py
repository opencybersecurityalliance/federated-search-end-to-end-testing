from behave import given, when, then
import json
import subprocess

@given(u'a STIX Bundle JSON file URL')
def step_impl(context):
    context.bundle_url = "https://raw.githubusercontent.com/"\
        "opencybersecurityalliance/stix-shifter/develop/data/cybox/2.json"


@when(u'I ping the URL')
def step_impl(context):
    auth_dict = {"auth": {"username": "", "password": ""}}
    url_dict = {"url": context.bundle_url}
    completed_process = subprocess.run(
        [
            "stix-shifter",
            "transmit",
            "stix_bundle",
            json.dumps(url_dict),
            json.dumps(auth_dict),
            "ping"
        ],
        capture_output=True
    )
    assert completed_process.returncode == 0
    context.result = completed_process.stdout


@then(u'I should get a Success return code')
def step_impl(context):
    result_dict = json.loads(context.result)
    assert(result_dict["success"] == True)
