venv:
	./federated-search-core/setup/create-venv.sh
check-venv:
	./federated-search-core/setup/check-venv.sh
checkout-stix-shifter:
	./federated-search-core/stix-shifter/setup/checkout-stix-shifter.sh
install-stix-shifter: check-venv checkout-stix-shifter
	./federated-search-core/stix-shifter/setup/install-stix-shifter.sh
checkout-kestrel:
	./application-test/kestrel/setup/checkout-kestrel.sh
install-kestrel: check-venv checkout-kestrel
	./application-test/kestrel/setup/install-kestrel.sh
install-kestrel-stix-shifter: export STIX_SHIFTER_TEST_VERSION=9.9.99
install-kestrel-stix-shifter: check-venv install-stix-shifter install-kestrel

install-elastic:
	./federated-search-core/setup/elastic-ecs/install-elastic.sh
import-data-elastic:
	./federated-search-core/setup/elastic-ecs/import-data.sh
import-data-elastic-scalability:
	./federated-search-core/setup/elastic-ecs/import-data.sh --data-indexes "win-52-elasticagent-500k-benign-20230523"
elastic: install-elastic import-data-elastic

deploy-kestrel: export KESTREL_STIXSHIFTER_CONFIG=${HOME}/fedsearchtest/kestrel-stixshifter-config.yaml
deploy-kestrel: check-venv
	./application-test/kestrel/setup/deploy-kestrel.sh

checkout-kestrel-analytics:
	./application-test/kestrel-analytics/setup/checkout-kestrel-analytics.sh
install-kestrel-analytics: checkout-kestrel-analytics
	./application-test/kestrel-analytics/setup/install-kestrel-analytics.sh

setup-test-env-kestrel-elastic: check-venv install-kestrel elastic deploy-kestrel install-kestrel-analytics

setup-test-env-kestrel-stix-shifter-elastic: check-venv install-kestrel-stix-shifter elastic deploy-kestrel install-kestrel-analytics

test-kestrel-elastic: check-venv
	./application-test/kestrel/test/run-tests.sh
test-kestrel-elastic-scalability: check-venv
	./application-test/kestrel/test/run-scalability-tests.sh

clean-elastic:
	./federated-search-core/setup/elastic-ecs/clean-elastic.sh
clean-data:
	rm -rf ${HOME}/fedsearchtest/data
clean-analytics:
	./application-test/kestrel-analytics/setup/clean-analytics.sh
clean-all: clean-elastic clean-data clean-analytics
	rm -rf ${HOME}/fedsearchtest
