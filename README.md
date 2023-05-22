# federated-search-end-to-end-testing
Open-source end-to-end testing framework for applications built on top of STIX-Shifter with live data sources

## Running the Tests Locally
### Supported platforms
The local build of the testing environment was implemented and tested on Ubuntu 20.04.  It was also tested on MacOS.
### Prerequisites
Ensure the following are installed on the test machine:
* docker
* python and pip (3.8 or later)
* virtualenv or venv
* make
### Creating and Activating a Python Virtual Environment
Triggered with:
```
make venv
source ${HOME}/fedsearchtest/fedsearchtest/bin/activate
```
This step will:
  * Create a directory named `fedsearchtest` in test user's home directory (`${HOME}`)
  * Create the `fedsearchtest` virtual environment
  * Activate the `fedsearchtest` virtual environment

### Bringing Up the Testing Environment
Currently, the local workflow supports setting up a testing environment for one application that uses STIX-Shifter: Kestrel - a threat hunting application.  The live data source currently supported is Elasticsearch.  We can either build both Kestrel and STIX-Shifter from source code (using the `setup-test-env-kestrel-stix-shifter-elastic` target) , or build only Kestrel from source code, and download STIX-Shifter packages from `pypi` (using the `setup-test-env-kestrel-elastic` target).

Triggered with:
```
make setup-test-env-kestrel-stix-shifter-elastic
make setup-test-env-kestrel-elastic
```

This step will:
  * Checkout the code for:
    * stix-shifter (`checkout-stix-shifter`, if STIX-Shifter will be built from source code)
    * kestrel (`checkout-kestrel`)
    * kestrel analytics (`checkout-kestrel-analytics`)
  * Build from code:
    * stix-shifter (`install-stix-shifter`, if STIX-Shifter will be built from source code)
    * kestrel (`install-kestrel`)
    * kestrel analytics (`install-kestrel-analytics`) - create a Docker image of the [`domainnamelookup` Kestrel analytics](https://github.com/opencybersecurityalliance/kestrel-analytics/tree/release/analytics/domainnamelookup)
  * Bring up, configure and load test data into an Elasticsearch instance (`elastic`, `install-elastic` and `import-data-elastic`)
    * Create a docker network named `elastic`
    * Create a docker instance of elasticsearch, named `es01test`
    * Store the password for `elastic` user on `es01test` in the file `${HOME}/fedsearchtest/.es_pwd`
    * Import three elastic indexes in the newly created elasticsearch instance
  * Finalize the deployment (`deploy-kestrel`):
    * Configure the STIX-Shifter profiles used by Kestrel
    * Run [a test huntbook](upper-layer-integration/kestrel/test/huntflows/kestrel-test.hf) to test the deployment end-to-end.

For local runs, this step can be controlled using the following environment variables.  
  * `STIX_SHIFTER_BRANCH` specifies which branch of the STIX-Shifter code to check out (default value: `develop`)
  * `STIX_SHIFTER_REPO` specifies the name of the STIX-Shifter repository (default value: `stix-shifter`)
  * `STIX_SHIFTER_ORG` specifies the organization from which STIX-Shifter code is checked out ( default value: `opencybersecurityalliance`)
  * `KESTREL_BRANCH` specifies which branch of the Kestrel code to check out (default value: `develop`)
  * `KESTREL_REPO` specifies the name of the Kestrel repository (default value: `kestrel-lang`)
  * `KESTREL_ORG` specifies the organization from which Kestrel code is checked out ( default value: `opencybersecurityalliance`)
  * `KESTREL_ANALYTICS_BRANCH` specifies which branch of the Kestrel analytics code to download (default value: `release`)
  * `KESTREL_ANALYTICS_REPO` specifies the name of the Kestrel Analytics repository (default value: `kestrel-analytics`)
  * `KESTREL_ANALYTICS_ORG` specifies the organization from which Kestrel Analytics code is checked out ( default value: `opencybersecurityalliance`)

### Running the Tests
Triggered with:
```
make test-kestrel-elastic
```
This step will:
  * Install [behave](https://github.com/behave/behave) package
  * Run end-to-end tests using [behave](https://github.com/behave/behave)

The tests are using three Kestrel hunt books: [start hunt from TTPs](upper-layer-integration/kestrel/test/huntflows/kestrel-start-hunt-from-ttps.hf), [cross-host campaign discovery](upper-layer-integration/kestrel/test/huntflows/kestrel-cross-host-campaign-discovery.hf), and [apply analytics in a hunt](upper-layer-integration/kestrel/test/huntflows/kestrel-analytics.hf) that have been derived from the [Kestrel notebooks presented at Black Hat 22](https://github.com/opencybersecurityalliance/kestrel-huntbook/tree/main/blackhat22)

### Cleaning Up

Cleanup frees the resources and removes the files used by the tests. It can uninstall the entire testing environment, or parts of it (the Elasticsearch instance using `make clean-elastic`, the Kestrel Analytics using `make clean-analyrics`) from a local machine. Triggered with:
```
make clean-all
```

This step will:
 * Remove the Elasticsearch data source (`clean-elastic`)
   * Remove the `es01test` Docker container containing the Elasticsearch instance and the imported test data.
 * Remove the Kestrel Analytics (`clean-analytics`)
   * Remove the analytics containers spawned during testing
   * Remove the Kestrel analytics Docker images spawned during testing
 * Remove the data files downloaded or extracted from archives (`clean-data`)
 * Remove the entire `${HOME}/fedsearchtest` directory, including:
   * The cloned GitHub source code
   * The data files downloaded or extracted from archives
   * The python virtual environment where testing took place 


## Running the Tests Using GitHub Actions

Currently, there are two GitHub Actions testing workflows for the Kestrel threat hunting application. 
* [The Kestrel end-to-end testing flow](.github/workfows/kestrel-end-to-end-testing-flow.yml) builds Kestrel from source code, and tests Kestrel with the latest release of the STIX-Shifter packages and an Elasticsearch data store. 
* [The STIX-Shifter and Kestrel end-to-end testing flow](.github/workfows/stix-shifter-kestrel-testing-flow.yml) builds both STIX-Shifter and Kestrel from source code, and tests Kestrel with an Elasticsearch data store.

Both workflows can be triggered manually from this testing repository.  [The Kestrel end-to-end testing flow](.github/workfows/kestrel-end-to-end-testing-flow.yml) has these input variables:
  * `branch` specifies which branch of the Kestrel code to check out (default value: `develop`)
  * `repository` specifies the name of the Kestrel repository (default value: `kestrel-lang`)
  * `organization` specifies the organization from which Kestrel code is checked out ( default value: `opencybersecurityalliance`)

The [The STIX-Shifter and Kestrel end-to-end testing flow](.github/workfows/stix-shifter-kestrel-testing-flow.yml), has these input variables:
  * `stix_shifter_branch` specifies which branch of the STIX-Shifter code to check out (default value: `develop`)
  * `stix_shifter_repository` specifies the name of the STIX-Shifter repository (default value: `stix-shifter`)
  * `stix_shifter_organization` specifies the organization from which STIX-Shifter code is checked out ( default value: `opencybersecurityalliance`)
  * `kestrel_branch` specifies which branch of the Kestrel code to check out (default value: `develop`)
  * `kestrel_repository` specifies the name of the Kestrel repository (default value: `kestrel-lang`)
  * `kestrel_organization` specifies the organization from which Kestrel code is checked out ( default value: `opencybersecurityalliance`)

### Remote GitHub Actions Workflow Invocation
[The Kestrel end-to-end testing flow](.github/workfows/kestrel-end-to-end-testing-flow.yml) can be triggered remotely from the [Kestrel repository](https://github.com/opencybersecurityalliance/kestrel-lang) using [the Kestrel integration testing workflow](https://github.com/opencybersecurityalliance/kestrel-lang/blob/develop/.github/workflows/integration-testing.yml). The remote activation will take place under these three scenarios:
1. Manual activation from the [Kestrel repository Actions](https://github.com/opencybersecurityalliance/kestrel-lang/actions/workflows/integration-testing.yml).  The values of the variables `branch`, `repository` and `organization` are input using the GitHub Actions UI. 
2. A `push` event in the `src/**` folder of any of these branches: `develop`, `develop_*`, or `release`. The values of the input variables `branch`, `repository` and `organization` will be copied from the `github.event` structure.
3. A pull request that modifies code in the `src/**` folder of any of these branches: `develop`, `develop_*`, or `release` is opened, synchronized, or reopened. The values of the input variables `branch`, `repository` and `organization` will be copied from the `head` section of the pull request.