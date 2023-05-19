.PHONY: all checkout install-elastic venv install-code import-data clean-elastic clean-data clean-all install-all check-deployment
venv:
	./federated-search-core/setup/create-venv.sh
check-venv:
	./federated-search-core/setup/check-venv.sh
checkout-stix-shifter:
	./federated-search-core/setup/stix-shifter/checkout-stix-shifter.sh
install-stix-shifter: check-venv checkout-stix-shifter
	./federated-search-core/setup/stix-shifter/install-stix-shifter.sh
checkout-kestrel:
	./upper-layer-integration/kestrel/setup/checkout-kestrel.sh
install-kestrel: check-venv checkout-kestrel
	./upper-layer-integration/kestrel/setup/install-kestrel.sh
install-kestrel-stix-shifter: export STIX_SHIFTER_TEST_VERSION=9.9.99
install-kestrel-stix-shifter: check-venv install-stix-shifter install-kestrel

install-elastic:
	./scripts/install-elastic.sh
checkout:
	./scripts/checkout-code.sh
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
