## Add a New STIX-Shifter Test (STIX Bundle)

### Creating a Local Test Environment

Cleanup any local testing environment in place by running (in the `${HOME}/federated-search-end-to-end-testing` directory):
```
make clean-all
```

Create and activate a new virtual environment for STIX-Shifter testing:
```
make venv
source ${HOME}/fedsearchtest/fedsearchtest/bin/activate
```

Build STIX-Shifter from source code:
```
make install-stix-shifter
```

### Create the Test Script
Create a `test` directory (if it does not exist already) under the STIX-Shifter folder (`federated-search-end-to-end-testing/fedeerated-search-core/stix-shifter`).

In this directory, create a script that installs `behave` and runs the tests. Because we are using a STIX Bundle there is no additional configuration (passing credentials to the script) needed:
```
# install the behave package
pip install behave
behave --logging-level CRITICAL
```

### Create Test Features and Scenarios Using Behave
We are going to create a simple test to ping a STIX Bundle URL using STIX-Shifter.  To write the tests using the behave framework follow these steps (please refer to the [Behave Documentation](https://behave.readthedocs.io/en/stable/tutorial.html) for a comprehensive list of all the features).
1. In the `federated-search-end-to-end-testing/fedeerated-search-core/stix-shifter/test` directory, create a `features` folder.  Inside that folder, create a feature file (`stix-bundle.feature`):
  ```
  Feature: Testing STIX-Shifter with STIX Bundle Connector
    As a Tester
    I need to test that STIX Shifter is running with a STIX Bundle Connector
    So that I can certify my STIX Bundle Connector
  Scenario: Ping the STIX Bundle JSON File
    Given a STIX Bundle JSON file URL
    When I ping the URL
    Then I should get a Success return code
  ```
2. Create the `federated-search-end-to-end-testing/fedeerated-search-core/stix-shifter/test/features/steps` directory. In the `features` directory, run `behave`:
  ```
  test/features$ behave
  Feature: Testing STIX-Shifter with STIX Bundle Connector # features/stix-bundle.feature:1
    As a Tester
    I need to test that STIX Shifter is running with a STIX Bundle Connector
    So that I can certify my STIX Bundle Connector
  Scenario: Ping the STIX Bundle JSON File  # features/stix-bundle.feature:5
    Given a STIX Bundle JSON file URL       # None
    When I ping the URL                     # None
    Then I should get a Success return code # None

  Failing scenarios:
    features/stix-bundle.feature:5  Ping the STIX Bundle JSON File

  0 features passed, 1 failed, 0 skipped
  0 scenarios passed, 1 failed, 0 skipped
  0 steps passed, 0 failed, 0 skipped, 3 undefined
  Took 0m0.000s

  You can implement step definitions for undefined steps with these snippets:

  @given(u'a STIX Bundle JSON file URL')
  def step_impl(context):
      raise NotImplementedError(u'STEP: Given a STIX Bundle JSON file URL')


  @when(u'I ping the URL')
  def step_impl(context):
      raise NotImplementedError(u'STEP: When I ping the URL')


  @then(u'I should get a Success return code')
  def step_impl(context):
      raise NotImplementedError(u'STEP: Then I should get a Success return code')
  ```

3. Implement the steps generated by `behave` in the previous step.  Create and edit the `federated-search-end-to-end-testing/fedeerated-search-core/stix-shifter/test/features/steps/steps.py` file:
  ```
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
  ```
4. Now the tests should complete successfully:
  ```
  test/features$ behave
  Feature: Testing STIX-Shifter with STIX Bundle Connector # features/stix-bundle.feature:1
    As a Tester
    I need to test that STIX Shifter is running with a STIX Bundle Connector
    So that I can certify my STIX Bundle Connector
  Scenario: Ping the STIX Bundle JSON File  # features/stix-bundle.feature:5
    Given a STIX Bundle JSON file URL       # features/steps/steps.py:5 0.000s
    When I ping the URL                     # features/steps/steps.py:11 0.430s
    Then I should get a Success return code # features/steps/steps.py:30 0.000s

  1 feature passed, 0 failed, 0 skipped
  1 scenario passed, 0 failed, 0 skipped
  3 steps passed, 0 failed, 0 skipped, 0 undefined
  Took 0m0.430s
  ```