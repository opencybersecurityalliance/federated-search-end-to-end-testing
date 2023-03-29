.PHONY: all checkout install-elastic venv install-code import-data clean-elastic clean-data clean-all install-all check-deployment
install-elastic:
	./install-elastic.sh
checkout:
	./checkout-code.sh
venv:
	./create-venv-local.sh
check-venv:
	./check-venv.sh
install-code:
	./install-stix-shifter-kestrel-local.sh
import-data:
	./import-data-local.sh
install-all: check-venv checkout install-code install-elastic import-data
check-deployment: check-venv
	./run_kestrel.sh
clean-elastic:
	sudo docker stop es01test; sudo docker rm es01test
clean-data:
	rm -rf ${HOME}/huntingtest/data
clean-all: clean-elastic clean-data
	rm -rf ${HOME}/huntingtest
bdd-tests: check-venv
	./run-bdd-tests.sh
