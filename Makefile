.PHONY: all checkout install-elastic venv install-code import-data clean-elastic clean-data clean-all install-all check-deployment
install-elastic:
	./scripts/install-elastic.sh
checkout:
	./scripts/checkout-code.sh
venv:
	./scripts/create-venv-local.sh
check-venv:
	./scripts/check-venv.sh
install-code:
	./scripts/install-stix-shifter-kestrel-local.sh
import-data:
	./scripts/import-data-local.sh
install-all: check-venv checkout install-code install-elastic import-data
check-deployment: check-venv
	./scripts/run_kestrel.sh
clean-elastic:
	sudo docker stop es01test; sudo docker rm es01test
clean-data:
	rm -rf ${HOME}/huntingtest/data
clean-all: clean-elastic clean-data
	rm -rf ${HOME}/huntingtest
bdd-tests: check-venv
	./scripts/run-bdd-tests.sh
