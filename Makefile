.PHONY: all binaries generated vendored

tempdir != mktemp -d
os != uname -s | awk '{print tolower($$0)}'
arch != uname -m
goarch != eval $$(go env) && echo "$$GOARCH"
ssh_configs != find ".ssh/config.d/" -type f \! -name '.*'
curl = curl --location --silent --fail
download = $(curl) --output $@

all: binaries vendored generated
vendored: .config/pythonrc.py .bash_completion.d/aws .bash_completion.d/docker-compose .bash_completion.d/docker-machine.bash .bash_completion.d/docker-machine.bash .travis/travis.sh .bash_completion.d/molecule
generated: .ssh/config .bash_completion.d/helm .bash_completion.d/kops .bash_completion.d/kubectl .bash_completion.d/kompose .bash_completion.d/minikube .bash_completion.d/pipenv .bash_completion.d/pandoc
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
	-$(download) https://github.com/rancher/rke/releases/download/v0.2.0/rke_$(os)-$(goarch)
	-chmod +x $@

.local/bin/docker-machine:
	-$(download) "https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-$(os)-$(arch)"
	-chmod +x $@

.local/bin/packer:
	$(curl) https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_$(os)_$(goarch).zip --output $(tempdir)/packer.zip
	unzip -d $(tempdir) $(tempdir)/packer.zip
	install -m 755 $(tempdir)/packer $@
	rm $(tempdir)/packer*

.local/bin/terraform:
	$(curl) https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_$(os)_$(goarch).zip --output $(tempdir)/terraform.zip
	unzip -d $(tempdir) $(tempdir)/terraform.zip
	install -m 755 $(tempdir)/terraform $@
	rm $(tempdir)/terraform*

.local/bin/vault:
	$(curl) https://releases.hashicorp.com/vault/1.1.0/vault_1.1.0_$(os)_$(goarch).zip --output $(tempdir)/vault.zip
	unzip -d $(tempdir) $(tempdir)/vault.zip
	install -m 755 $(tempdir)/vault $@
	rm $(tempdir)/vault*

.local/bin/kubectl:
	-$(download) "https://storage.googleapis.com/kubernetes-release/release/v1.14.0/bin/$(os)/$(goarch)/kubectl"
	-chmod +x $@

.local/bin/kops:
	-$(download) "https://github.com/kubernetes/kops/releases/download/1.11.1/kops-$(os)-$(goarch)"
	-chmod +x $@

.local/bin/kompose:
	-$(download) https://github.com/kubernetes/kompose/releases/download/v1.17.0/kompose-$(os)-$(goarch)
	-chmod +x $@

.local/bin/minikube:
	-$(download) https://storage.googleapis.com/minikube/releases/latest/minikube-$(os)-$(goarch)
	-chmod +x $@

.local/bin/docker-machine-driver-kvm2:
	-$(download) https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2
	-chmod +x $@

.local/bin/helm:
	mkdir -p $(tempdir)/helm
	-$(curl) https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-$(os)-$(goarch).tar.gz | tar -zxf - -C $(tempdir)/helm/
	-install -m 755 $(tempdir)/helm/$(os)-$(goarch)/helm $@
	rm -r $(tempdir)/helm

.bash_completion.d/helm: .local/bin/helm
	-$$(basename $@) completion bash > $@

.bash_completion.d/kompose: .local/bin/kompose
	-$$(basename $@) completion bash > $@

.bash_completion.d/kops: .local/bin/kops
	-$$(basename $@) completion bash > $@

.bash_completion.d/kubectl: .local/bin/kubectl
	-$$(basename $@) completion bash > $@

.bash_completion.d/minikube: .local/bin/minikube
	-$$(basename $@) completion bash > $@

.bash_completion.d/molecule:
	$(download) https://raw.githubusercontent.com/ansible/molecule/1.25.1/asset/bash_completion/molecule.bash-completion.sh

.bash_completion.d/pipenv:
	-bash -c 'pipenv --completion > $@'

.bash_completion.d/pandoc:
	-pandoc --bash-completion > $@
