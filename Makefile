.PHONY: all binaries

ssh_configs := $(wildcard .ssh/config.d/*)
download = curl --silent --location --fail --output $@

all: .config/pythonrc.py .ssh/config .bash_completion.d/aws .bash_completion.d/docker-compose .bash_completion.d/docker-machine.bash .bash_completion.d/docker-machine.bash .travis/travis.sh binaries

binaries: .local/share/bfg/bfg.jar .local/bin/rke .local/bin/docker-machine .local/bin/packer .local/bin/terraform .local/bin/vault .local/bin/kubectl .local/bin/kops .local/bin/kompose .local/bin/minikube 

.ssh/config: $(ssh_configs)
	find ".ssh/config.d/" -type f \! -name '.*' -print0 | sort --zero | xargs -0 cat > ".ssh/config"

.bash_completion.d/docker-compose:
	$(download) https://raw.githubusercontent.com/docker/compose/1.23.2/contrib/completion/bash/docker-compose 

.bash_completion.d/docker-machine.bash:
	$(download) https://raw.githubusercontent.com/docker/machine/v0.16.0/contrib/completion/bash/docker-machine.bash

.bash_completion.d/fabric-completion.bash:
	$(download) https://raw.githubusercontent.com/kbakulin/fabric-completion/master/fabric-completion.bash

.config/pythonrc.py:
	$(download) https://raw.githubusercontent.com/lonetwin/pythonrc/master/pythonrc.py

.travis/travis.sh:
	mkdir -p .travis
	$(download) https://raw.githubusercontent.com/travis-ci/travis.rb/master/assets/travis.sh

.local/share/bfg/bfg.jar:
	$(download) 'https://search.maven.org/remote_content?g=com.madgag&a=bfg&v=LATEST'

.local/bin/rke:
	$(download) https://github.com/rancher/rke/releases/download/v0.2.0/rke_darwin-amd64
	chmod +x $@

.local/bin/docker-machine:
	$(download) "https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-$$(uname -s)-$$(uname -m)"
	chmod +x $@

.local/bin/packer:
	$(download) https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_linux_amd64.zip
	chmod +x $@

.local/bin/terraform:
	$(download) https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
	chmod +x $@

.local/bin/vault:
	$(download) https://releases.hashicorp.com/vault/1.1.0/vault_1.1.0_linux_amd64.zip
	chmod +x $@

.local/bin/kubectl:
	$(download) "https://storage.googleapis.com/kubernetes-release/release/$$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
	chmod +x $@

.local/bin/kops:
	$(download) "https://github.com/kubernetes/kops/releases/download/$$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64"
	chmod +x $@

.local/bin/kompose:
	$(download) https://github.com/kubernetes/kompose/releases/download/v1.17.0/kompose-linux-amd64
	chmod +x $@

.local/bin/minikube:
	$(download) https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	chmod +x $@

.local/bin/docker-machine-driver-kvm2:
	$(download) https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2
	chmod +x $@
