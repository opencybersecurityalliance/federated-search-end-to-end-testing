# hunting-stack-testing
Open-source integration testing framework to test hunting stacks with live data sources

## Building the testing environment locally
### Supported platforms
The local build of the testing environment was implemented and tested on Ubuntu 20.04.
### Prerequisites
Ensure the following are installed on the test machine:
* docker
* python and pip (3.8 or later)
* virtualenv
* make
### Create and activate a python virtual environment
Triggered with:
```
make venv
source ${HOME}/huntingtest/huntingtest/bin/activate
```
This step will:
  * Create a directory named `huntingtest` in test user's home directory (`${HOME}`).
  * Create the `huntingtest` virtual environment. 
  * Activate the `huntingtest` virtual environment.

### Bring up the testing environment
Triggered with:
```
make install-all
```
This step will:
  * Checkout the code for:
    * kestrel (`develop_stixshifter_v5` branch), and 
    * stix-shifter (`develop` branch).
  * Build stix-shifter and kestrel from the code.
  * Create a docker network named `elastic`.
  * Create a docker instance of elasticsearch, named `es01test`.
    * Store the password for `elastic` user on `es01test` in the file `${HOME}/es_pwd`.
  * Import three elastic indexes in the newly created elasticsearch instance.

TODO: 
  * Change the kestrel branch.
  * Allow checking out custom branches, tags, or even commits.

### End-to-end test of the deployed testing environment
Triggered with:
```
make check-deployment
```
This step will run [a test huntbook](kestrel-test.hf) to test the deployment end-to-end.

## Running BDD tests
Triggered with:
```
make bdd-tests
```
This step will:
  * Install [behave](https://github.com/behave/behave) package
  * Run integration tests using [behave](https://github.com/behave/behave).

TODO:
  * Currently, [only one feature testing the deployment](features/deployment-test.feature) is available.
  * Add more features and scenarios to the integration tests.

## Running the integration tests using github actions
The github actions workflow for integration testing is specified [here](.github/workflows/github-actions-flow.yml).

The github actions workflow is currently triggered every time a new commit is pushed, or a pull request is created in this repository. The workflow can also be triggered manually.   

TODO:
  * Start the workflow whenever a push request is created in the kestrel-lang or stix-shifter repositories.