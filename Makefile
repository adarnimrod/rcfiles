.PHONY: all binaries generated vendored
DESTDIR ?= .local
tempdir != mktemp -d
os != uname -s | awk '{print tolower($$0)}'
arch != uname -m
goos != go env GOOS
goarch != go env GOARCH
ssh_configs != find ".ssh/config.d/" -type f \! -name '.*' | sort
curl = curl --location --silent --fail
download = $(curl) --output $@
ansible-local = ansible localhost -c local -i localhost, -e "ansible_python_interpreter=$$(which python3)"

all: binaries vendored generated
vendored: .config/pythonrc.py .bash_completion.d/aws .bash_completion.d/docker-compose .bash_completion.d/docker-machine.bash .bash_completion.d/docker-machine.bash .travis/travis.sh .bash_completion.d/molecule Documents/bin/rabbitmqadmin .bash_completion.d/toolbox
generated: .ssh/config .bash_completion.d/helm .bash_completion.d/kops .bash_completion.d/kubectl .bash_completion.d/kompose .bash_completion.d/minikube .bash_completion.d/pipenv .bash_completion.d/pandoc .bash_completion.d/skaffold .bash_completion.d/rabbitmqadmin .ssh/localhost .ssh/localhost.pub .ssh/authorized_keys .bash_completion.d/minishift .bash_completion.d/oc .bash_completion.d/poetry
binaries: $(DESTDIR)/share/bfg/bfg.jar $(DESTDIR)/bin/rke $(DESTDIR)/bin/docker-machine $(DESTDIR)/bin/packer $(DESTDIR)/bin/terraform $(DESTDIR)/bin/vault $(DESTDIR)/bin/kubectl $(DESTDIR)/bin/kops $(DESTDIR)/bin/kompose $(DESTDIR)/bin/minikube $(DESTDIR)/bin/docker-machine-driver-kvm2 $(DESTDIR)/bin/kustomize $(DESTDIR)/bin/pack $(DESTDIR)/bin/skaffold $(DESTDIR)/bin/minishift $(DESTDIR)/bin/oc $(DESTDIR)/bin/docker-machine-driver-kvm $(DESTDIR)/bin/gomplate $(DESTDIR)/bin/envconsul $(DESTDIR)/bin/helm


## Binary files

$(DESTDIR)/share/bfg/bfg.jar:
	mkdir -p $$(dirname $@)
	$(download) 'https://search.maven.org/remote_content?g=com.madgag&a=bfg&v=LATEST'

$(DESTDIR)/bin/rke:
	mkdir -p $$(dirname $@)
	-$(download) https://github.com/rancher/rke/releases/download/v0.3.2/rke_$(os)-$(goarch)
	-chmod +x $@

$(DESTDIR)/bin/docker-machine:
	mkdir -p $$(dirname $@)
	-$(download) "https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-$(os)-$(arch)"
	-chmod +x $@

$(DESTDIR)/bin/packer:
	mkdir -p $$(dirname $@)
	$(curl) https://releases.hashicorp.com/packer/1.4.5/packer_1.4.5_$(os)_$(goarch).zip --output $(tempdir)/packer.zip
	unzip -d $(tempdir) $(tempdir)/packer.zip
	install -m 755 $(tempdir)/packer $@
	rm $(tempdir)/packer*

$(DESTDIR)/bin/terraform:
	mkdir -p $$(dirname $@)
	$(curl) https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_$(os)_$(goarch).zip --output $(tempdir)/terraform.zip
	unzip -d $(tempdir) $(tempdir)/terraform.zip
	install -m 755 $(tempdir)/terraform $@
	rm $(tempdir)/terraform*

$(DESTDIR)/bin/vault:
	mkdir -p $$(dirname $@)
	$(curl) https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_$(os)_$(goarch).zip --output $(tempdir)/vault.zip
	unzip -d $(tempdir) $(tempdir)/vault.zip
	install -m 755 $(tempdir)/vault $@
	rm $(tempdir)/vault*

$(DESTDIR)/bin/kubectl:
	mkdir -p $$(dirname $@)
	-$(download) "https://storage.googleapis.com/kubernetes-release/release/v1.16.2/bin/$(os)/$(goarch)/kubectl"
	-chmod +x $@

$(DESTDIR)/bin/kops:
	mkdir -p $$(dirname $@)
	-$(download) "https://github.com/kubernetes/kops/releases/download/1.14.1/kops-$(os)-$(goarch)"
	-chmod +x $@

$(DESTDIR)/bin/kompose:
	mkdir -p $$(dirname $@)
	-$(download) https://github.com/kubernetes/kompose/releases/download/v1.22.0/kompose-$(os)-$(goarch)
	-chmod +x $@

$(DESTDIR)/bin/minikube:
	mkdir -p $$(dirname $@)
	-$(download) https://storage.googleapis.com/minikube/releases/latest/minikube-$(os)-$(goarch)
	-chmod +x $@

$(DESTDIR)/bin/kustomize:
	mkdir -p $$(dirname $@)
	-$(curl) https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.8.7/kustomize_v3.8.7_$(os)_$(goarch).tar.gz | tar -zxC $(DESTDIR)/bin/

$(DESTDIR)/bin/docker-machine-driver-kvm2:
	mkdir -p $$(dirname $@)
	-$(download) https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2
	-chmod +x $@

$(DESTDIR)/bin/helm:
	mkdir -p $$(dirname $@)
	mkdir -p $(tempdir)/helm
	-$(curl) https://storage.googleapis.com/kubernetes-helm/helm-v2.16.0-$(os)-$(goarch).tar.gz | tar -zxf - -C $(tempdir)/helm/
	-install -m 755 $(tempdir)/helm/$(os)-$(goarch)/helm $@
	rm -r $(tempdir)/helm

$(DESTDIR)/bin/pack:
	mkdir -p $$(dirname $@)
	-$(curl) https://github.com/buildpack/pack/releases/download/v0.5.0/pack-v0.5.0-$(os).tgz | tar -xzC $(DESTDIR)/bin/

$(DESTDIR)/bin/skaffold:
	mkdir -p $$(dirname $@)
	-$(download) https://storage.googleapis.com/skaffold/releases/v0.41.0/skaffold-$(os)-$(goarch)
	-chmod +x $@

$(DESTDIR)/bin/minishift:
	mkdir -p $$(dirname $@)
	-$(curl) https://github.com/minishift/minishift/releases/download/v1.34.1/minishift-1.34.1-$(goos)-$(goarch).tgz | tar -xzC $(tempdir)
	-install -m 755 $(tempdir)/minishift-*/minishift $@
	-rm -r $(tempdir)/minishift-*

$(DESTDIR)/bin/oc:
	mkdir -p $$(dirname $@)
	-$(curl) https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-$(os)-64bit.tar.gz | tar -xzC $(tempdir)
	-install -m 755 $(tempdir)/openshift-*/oc $@
	-rm -r $(tempdir)/openshift-*

$(DESTDIR)/bin/docker-machine-driver-kvm:
	mkdir -p $$(dirname $@)
	-$(download) https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-ubuntu16.04
	-chmod +x $@

$(DESTDIR)/bin/gomplate:
	mkdir -p $$(dirname $@)
	-$(download) https://github.com/hairyhenderson/gomplate/releases/download/v3.5.0/gomplate_$(goos)-$(goarch)
	-chmod +x $@

$(DESTDIR)/bin/envconsul:
	mkdir -p $$(dirname $@)
	-$(curl) https://releases.hashicorp.com/envconsul/0.9.0/envconsul_0.9.0_$(goos)_$(goarch).tgz | tar -xzC $$(dirname $@) -f -


## Vendored files

.bash_completion.d/docker-compose:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/docker/compose/1.24.1/contrib/completion/bash/docker-compose

.bash_completion.d/docker-machine.bash:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/docker/machine/v0.16.2/contrib/completion/bash/docker-machine.bash

.bash_completion.d/fabric-completion.bash:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/kbakulin/fabric-completion/master/fabric-completion.bash

.config/pythonrc.py:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/lonetwin/pythonrc/0.8.4/pythonrc.py

.travis/travis.sh:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/travis-ci/travis.rb/master/assets/travis.sh

.bash_completion.d/molecule:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/ansible/molecule/1.25.1/asset/bash_completion/molecule.bash-completion.sh

Documents/bin/rabbitmqadmin:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/master/bin/rabbitmqadmin
	chmod +x $@

.bash_completion.d/toolbox:
	$(download) https://raw.githubusercontent.com/containers/toolbox/0.0.97/completion/bash/toolbox


## Generated files

.ssh/config: $(ssh_configs)
	mkdir -p $$(dirname $@)
	cat $(ssh_configs) > $@

.bash_completion.d/helm: $(DESTDIR)/bin/helm
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

.bash_completion.d/kompose: $(DESTDIR)/bin/kompose
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

.bash_completion.d/kops: $(DESTDIR)/bin/kops
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

.bash_completion.d/kubectl: $(DESTDIR)/bin/kubectl
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

.bash_completion.d/minikube: $(DESTDIR)/bin/minikube
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

.bash_completion.d/skaffold: $(DESTDIR)/bin/skaffold
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

.bash_completion.d/pipenv:
	mkdir -p $$(dirname $@)
	-bash -c 'pipenv --completion > $@'

.bash_completion.d/pandoc:
	mkdir -p $$(dirname $@)
	-pandoc --bash-completion > $@

.bash_completion.d/rabbitmqadmin: Documents/bin/rabbitmqadmin
	mkdir -p $$(dirname $@)
	-Documents/bin/rabbitmqadmin --bash-completion > $@

.ssh/localhost:
	ssh-keygen -t ecdsa -N '' -C localhost -f $@

.ssh/localhost.pub: .ssh/localhost
	ssh-keygen -y -f $< > $@

.ssh/authorized_keys: .ssh/localhost.pub
	-$(ansible-local) -m authorized_key -a "user=$$(whoami) key='$$(cat .ssh/localhost.pub)' key_options='from=\"127.0.0.1/8\"'"

.bash_completion.d/minishift: $(DESTDIR)/bin/minishift
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

.bash_completion.d/oc: $(DESTDIR)/bin/oc
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

.bash_completion.d/poetry:
	-poetry completions bash > $@
