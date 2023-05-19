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
	./federated-search-core/setup/elastic-ecs/install-elastic.sh
import-data-elastic:
	./federated-search-core/setup/elastic-ecs/import-data.sh
elastic: install-elastic import-data-elastic

deploy-kestrel: export KESTREL_STIXSHIFTER_CONFIG=${HOME}/fedsearchtest/kestrel-stixshifter-config.yaml
deploy-kestrel: check-venv
	./upper-layer-integration/kestrel/setup/deploy-kestrel.sh

install-kestrel-elastic: check-venv install-kestrel elastic deploy-kestrel

install-kestrel-stix-shifter-elastic: check-venv install-kestrel-stix-shifter elastic deploy-kestrel

clean-elastic:
	./federated-search-core/setup/elastic-ecs/clean-elastic.sh
clean-data:
	rm -rf ${HOME}/fedsearchtest/data
clean-analytics:
	./scripts/clean-analytics.sh
clean-all: clean-elastic clean-data clean-analytics
	rm -rf ${HOME}/fedsearchtest
bdd-tests: check-venv
	./scripts/run-bdd-tests-local.sh
