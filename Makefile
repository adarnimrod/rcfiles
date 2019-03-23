.PHONY: all binaries generated vendored

tempdir != mktemp -d
os != uname -s | awk '{print tolower($$0)}'
arch := amd64
ssh_configs != find ".ssh/config.d/" -type f \! -name '.*'
curl = curl --location --silent --fail
download = $(curl) --output $@

all: vendored generated binaries
vendored: .config/pythonrc.py .bash_completion.d/aws .bash_completion.d/docker-compose .bash_completion.d/docker-machine.bash .bash_completion.d/docker-machine.bash .travis/travis.sh
generated: .ssh/config
binaries: .local/share/bfg/bfg.jar .local/bin/rke .local/bin/docker-machine .local/bin/packer .local/bin/terraform .local/bin/vault .local/bin/kubectl .local/bin/kops .local/bin/kompose .local/bin/minikube .local/bin/docker-machine-driver-kvm2

.ssh/config: $(ssh_configs)
	cat $(ssh_configs) > $@

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
	$(download) https://github.com/rancher/rke/releases/download/v0.2.0/rke_$(os)-$(arch)
	chmod +x $@

.local/bin/docker-machine:
	$(download) "https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-$(os)-$$(uname -m)"
	chmod +x $@

.local/bin/packer:
	$(curl) https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_$(os)_$(arch).zip --output $(tempdir)/packer.zip
	unzip -d $(tempdir) $(tempdir)/packer.zip
	install -m 755 $(tempdir)/packer $@
	rm $(tempdir)/packer*

.local/bin/terraform:
	$(curl) https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_$(os)_$(arch).zip --output $(tempdir)/terraform.zip
	unzip -d $(tempdir) $(tempdir)/terraform.zip
	install -m 755 $(tempdir)/terraform $@
	rm $(tempdir)/terraform*

.local/bin/vault:
	$(curl) https://releases.hashicorp.com/vault/1.1.0/vault_1.1.0_$(os)_$(arch).zip --output $(tempdir)/vault.zip
	unzip -d $(tempdir) $(tempdir)/vault.zip
	install -m 755 $(tempdir)/vault $@
	rm $(tempdir)/vault*

.local/bin/kubectl:
	$(download) "https://storage.googleapis.com/kubernetes-release/release/v1.13.4/bin/$(os)/$(arch)/kubectl"
	chmod +x $@

.local/bin/kops:
	$(download) "https://github.com/kubernetes/kops/releases/download/1.11.1/kops-$(os)-$(arch)"
	chmod +x $@

.local/bin/kompose:
	$(download) https://github.com/kubernetes/kompose/releases/download/v1.17.0/kompose-$(os)-$(arch)
	chmod +x $@

.local/bin/minikube:
	$(download) https://storage.googleapis.com/minikube/releases/latest/minikube-$(os)-$(arch)
	chmod +x $@

.local/bin/docker-machine-driver-kvm2:
	$(download) https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2
	chmod +x $@
