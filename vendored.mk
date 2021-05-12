curl = curl --location --silent --fail
download = $(curl) --output $@

.PHONY: vendored
all: vendored

vendored: .bash_completion.d/docker-compose
.bash_completion.d/docker-compose:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose

vendored: .bash_completion.d/docker-machine.bash
.bash_completion.d/docker-machine.bash:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/docker/machine/v0.16.2/contrib/completion/bash/docker-machine.bash

vendored: .bash_completion.d/fabric-completion.bash
.bash_completion.d/fabric-completion.bash:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/kbakulin/fabric-completion/master/fabric-completion.bash

vendored: .config/pythonrc.py
.config/pythonrc.py:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/lonetwin/pythonrc/0.8.4/pythonrc.py

vendored: .bash_completion.d/molecule
.bash_completion.d/molecule:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/ansible-community/molecule/1.25.1/asset/bash_completion/molecule.bash-completion.sh

vendored: Documents/bin/rabbitmqadmin
Documents/bin/rabbitmqadmin:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/rabbitmq/rabbitmq-server/v3.8.16/deps/rabbitmq_management/bin/rabbitmqadmin
	chmod +x $@

