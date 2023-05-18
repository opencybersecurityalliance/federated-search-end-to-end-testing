.PHONY: all checkout install-elastic venv install-code import-data clean-elastic clean-data clean-all install-all check-deployment
venv:
	./federated-search-core/setup/create-venv.sh
install-elastic:
	./scripts/install-elastic.sh
checkout:
	./scripts/checkout-code.sh
check-venv:
	./scripts/check-venv.sh
install-code:
	./scripts/install-stix-shifter-kestrel-local.sh
import-data:
	./scripts/import-data.sh --gh-org cmadam
install-all: check-venv checkout install-code install-elastic import-data
check-deployment: check-venv
	./scripts/run_kestrel.sh
clean-elastic:
	./scripts/clean-elastic.sh
clean-data:
	rm -rf ${HOME}/huntingtest/data
clean-analytics:
	./scripts/clean-analytics.sh
clean-all: clean-elastic clean-data clean-analytics
	rm -rf ${HOME}/huntingtest
bdd-tests: check-venv
	./scripts/run-bdd-tests-local.sh
