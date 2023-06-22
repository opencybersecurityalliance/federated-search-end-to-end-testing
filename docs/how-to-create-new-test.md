## Steps to Add a New Test

### Create the Test Script
Create a `test` directory (if it does not exist already) under the STIX-Shifter folder (`fedeerated-search-core/stix-shifter`, or under the folder of the application that you want to test (`application-test/<application-name>`).

In this directory, create a script that follows this template:
```
# install the behave package
pip install behave
# add any credentials needed by the tests to the configuration files
# run the tests in the test directory
CRT_DIR="${PWD}"
cd application-test/<app-name>/test || exit
behave --logging-level CRITICAL
cd "${CRT_DIR}" || exit
```

### Create Test Features and Scenarios Using Behave
To write the tests using the behave framework follow these steps (please refer to the [Behave Documentation](https://behave.readthedocs.io/en/stable/tutorial.html) for a comprehensive list of all the features).
1. In the `test` directory for your application, create a `features` folder.  Inside that folder, create a feature file (`quickstart.feature`):
   ```
   Feature: Quick Start with Behave
    As a Tester
    I need an example
    So that I can get started with Behave 
   Scenario: Use context to pass variables between steps
    Given a variable equal to 3
    And a variable equal to 2
    When I add the two variables
    Then their sum should be 5
   ```
   This file uses the [Gherkin Language](https://cucumber.io/docs/gherkin/) to specify business behavior without going in the details of implementation.
2. Create a `test/features/steps` directory. In the features directory, run `behave`:
   ```
   test/features$ behave
   Feature: Quick Start with Behave # quickstart.feature:1
     As a Tester
     I need an example
     So that I can get started with Behave
   Scenario: Use context to pass variables between steps  # quickstart.feature:6
    Given a variable equal to 3                        # None
    And a variable equal to 2                          # None
    When I add the two variables                       # None
    Then their sum should be 5                         # None

   Failing scenarios:
     quickstart.feature:6  Use context to pass variables between steps

   0 features passed, 1 failed, 0 skipped
   0 scenarios passed, 1 failed, 0 skipped
   0 steps passed, 0 failed, 0 skipped, 4 undefined
   Took 0m0.000s

   You can implement step definitions for undefined steps with these snippets:

   @given(u'a variable equal to 3')
   def step_impl(context):
     raise NotImplementedError(u'STEP: Given a variable equal to 3')

   @given(u'a variable equal to 2')
   def step_impl(context):
     raise NotImplementedError(u'STEP: Given a variable equal to 2')

   @when(u'I add the two variables')
   def step_impl(context):
     raise NotImplementedError(u'STEP: When I add the two variables')

   @then(u'their sum should be 5')
   def step_impl(context):
     raise NotImplementedError(u'STEP: Then their sum should be 5')
   ```
  The run failed, because there is no implementation for the tests, but it provided us with a skeleton for the `steps.py` file.

3. Implement the steps.  Create and edit the `tests/features/steps/steps.py` file:
  ```
  from behave import given, when, then

  @given(u'a variable equal to 3')
  def step_impl(context):
      context.x = 3

  @given(u'a variable equal to 2')
  def step_impl(context):
      context.y = 2

  @when(u'I add the two variables')
  def step_impl(context):
      context.sum = context.x + context.y

  @then(u'their sum should be 5')
  def step_impl(context):
      assert context.sum == 5
  ```
4. Now the tests should complete successfully:
  ```
  test/features$ behave
  Feature: Quick Start with Behave # quickstart.feature:1
    As a Tester
    I need an example
    So that I can get started with Behave
    Scenario: Use context to pass variables between steps  # quickstart.feature:6
      Given a variable equal to 3                          # steps/steps.py:3 0.000s
      And a variable equal to 2                            # steps/steps.py:7 0.000s
      When I add the two variables                         # steps/steps.py:11 0.000s
      Then their sum should be 5                           # steps/steps.py:15 0.000s

  1 feature passed, 0 failed, 0 skipped
  1 scenario passed, 0 failed, 0 skipped
  4 steps passed, 0 failed, 0 skipped, 0 undefined
  Took 0m0.000s
  ```
