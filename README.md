# hunting-stack-testing
Open-source integration testing framework to test hunting stacks with live data sources

## Building the testing environment locally
### Supported platforms
The local build of the testing environment was implemented and tested on Ubuntu 20.04.  It was also tested on MacOS.
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
  * Create a directory named `huntingtest` in test user's home directory (`${HOME}`)
  * Create the `huntingtest` virtual environment
  * Activate the `huntingtest` virtual environment

### Bring up the testing environment
Triggered with:
```
make install-all
```
This step will:
  * Checkout the code for:
    * stix-shifter
    * kestrel 
    * kestrel analytics
  * Build stix-shifter and kestrel from the code
  * Create a docker network named `elastic`
  * Create a docker instance of elasticsearch, named `es01test`
    * Store the password for `elastic` user on `es01test` in the file `${HOME}/huntingtest/.es_pwd`
  * Import three elastic indexes in the newly created elasticsearch instance

This step can be controlled using the following environment variables.  
For local runs:
  * `STIX_SHIFTER_BRANCH` specifies which branch of the STIX-Shifter code to check out (default value: `develop`)
  * `KESTREL_BRANCH` specifies which branch of the Kestrel code to check out (default value: `develop`)
  * `KESTREL_ANALYTICS_BRANCH` specifies which branch of the Kestrel analytics code to download (default value: `release`)
  * `STIX_SHIFTER_ORG` specifies the organization from which STIX-Shifter code is checked out ( default value: `opencybersecurityalliance`)
  * `KESTREL_ORG` specifies the organization from which Kestrel code is checked out ( default value: `opencybersecurityalliance`)
  * `KESTREL_ANALYTICS_ORG` specifies the organization from which Kestrel Analytics code is checked out ( default value: `opencybersecurityalliance`)

For GitHub Actions runs, the variables are defined in the `env` section of the workflow.
 
### End-to-end test of the deployed testing environment
Triggered with:
```
make check-deployment
```
This step will run [a test huntbook](huntbooks/kestrel-test.hf) to test the deployment end-to-end.

## Running BDD tests
Triggered with:
```
make bdd-tests
```
This step will:
  * Install [behave](https://github.com/behave/behave) package
  * Create a Docker image of the [`domainnamelookup` Kestrel analytics](https://github.com/opencybersecurityalliance/kestrel-analytics/tree/release/analytics/domainnamelookup)
  * Run integration tests using [behave](https://github.com/behave/behave)

The integration tests are using three Kestrel hunt books: [start hunt from TTPs](huntbooks/kestrel-start-hunt-from-ttps.hf), [cross-host campaign discovery](huntbooks/kestrel-cross-host-campaign-discovery.hf), and [apply analytics in a hunt](huntbooks/kestrel-analytics.hf) that have been derived from the [Kestrel notebooks presented at Black Hat 22](https://github.com/opencybersecurityalliance/kestrel-huntbook/tree/main/blackhat22)

## Running the integration tests using github actions
The github actions workflow for integration testing is specified [here](.github/workflows/github-actions-flow.yml).

The github actions workflow is currently triggered every time a new commit is pushed, or a pull request is created in this repository. The workflow can also be triggered manually.   

TODO:
  * Start the workflow whenever a push request is created in the kestrel-lang or stix-shifter repositories.
