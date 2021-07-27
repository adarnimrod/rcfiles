DESTDIR ?= .local
tempdir != mktemp -d
os != uname -s | awk '{print tolower($$0)}'
arch != uname -m
goos != go env GOOS
goarch != go env GOARCH
curl = curl --location --silent --fail
download = $(curl) --output $@

.PHONY: binaries
all: binaries

binaries: $(DESTDIR)/bin/hugo
$(DESTDIR)/bin/hugo:
	mkdir -p $$(dirname $@)
	$(curl) https://github.com/gohugoio/hugo/releases/download/v0.83.1/hugo_0.83.1_Linux-64bit.tar.gz | tar -xzC "$$(dirname '$@')" "$$(basename '$@')"

binaries: $(DESTDIR)/share/bfg/bfg.jar
$(DESTDIR)/share/bfg/bfg.jar:
	mkdir -p $$(dirname $@)
	$(download) 'https://search.maven.org/remote_content?g=com.madgag&a=bfg&v=LATEST'

binaries: $(DESTDIR)/bin/rke
$(DESTDIR)/bin/rke:
	mkdir -p $$(dirname $@)
	-$(download) https://github.com/rancher/rke/releases/download/v1.2.8/rke_$(os)-$(goarch)
	-chmod +x $@

binaries: $(DESTDIR)/bin/docker-machine
$(DESTDIR)/bin/docker-machine:
	mkdir -p $$(dirname $@)
	-$(download) "https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-$(os)-$(arch)"
	-chmod +x $@

binaries: $(DESTDIR)/bin/packer
$(DESTDIR)/bin/packer:
	mkdir -p $$(dirname $@)
	$(curl) https://releases.hashicorp.com/packer/1.7.2/packer_1.7.2_$(os)_$(goarch).zip --output $(tempdir)/packer.zip
	unzip -d $(tempdir) $(tempdir)/packer.zip
	install -m 755 $(tempdir)/packer $@
	rm $(tempdir)/packer*

binaries: $(DESTDIR)/bin/terraform
$(DESTDIR)/bin/terraform:
	mkdir -p $$(dirname $@)
	$(curl) https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_$(os)_$(goarch).zip --output $(tempdir)/terraform.zip
	unzip -d $(tempdir) $(tempdir)/terraform.zip
	install -m 755 $(tempdir)/terraform $@
	rm $(tempdir)/terraform*

binaries: $(DESTDIR)/bin/terragrunt
$(DESTDIR)/bin/terragrunt:
	mkdir -p $$(dirname $@)
	-$(download) https://github.com/gruntwork-io/terragrunt/releases/download/v0.22.5/terragrunt_$(goos)_$(goarch)
	-chmod +x '$@'

binaries: $(DESTDIR)/bin/vault
$(DESTDIR)/bin/vault:
	mkdir -p $$(dirname $@)
	$(curl) https://releases.hashicorp.com/vault/1.7.1/vault_1.7.1_$(os)_$(goarch).zip --output $(tempdir)/vault.zip
	unzip -d $(tempdir) $(tempdir)/vault.zip
	install -m 755 $(tempdir)/vault $@
	rm $(tempdir)/vault*

binaries: $(DESTDIR)/bin/kubectl
$(DESTDIR)/bin/kubectl:
	mkdir -p $$(dirname $@)
	-$(download) "https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/$(os)/$(goarch)/kubectl"
	-chmod +x $@

binaries: $(DESTDIR)/bin/kops
$(DESTDIR)/bin/kops:
	mkdir -p $$(dirname $@)
	-$(download) "https://github.com/kubernetes/kops/releases/download/v1.20.0/kops-$(os)-$(goarch)"
	-chmod +x $@

binaries: $(DESTDIR)/bin/kompose
$(DESTDIR)/bin/kompose:
	mkdir -p $$(dirname $@)
	-$(download) https://github.com/kubernetes/kompose/releases/download/v1.22.0/kompose-$(os)-$(goarch)
	-chmod +x $@

binaries: $(DESTDIR)/bin/minikube
$(DESTDIR)/bin/minikube:
	mkdir -p $$(dirname $@)
	-$(download) https://storage.googleapis.com/minikube/releases/latest/minikube-$(os)-$(goarch)
	-chmod +x $@

binaries: $(DESTDIR)/bin/kustomize
$(DESTDIR)/bin/kustomize:
	mkdir -p $$(dirname $@)
	-$(curl) https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.1.2/kustomize_v4.1.2_$(os)_$(goarch).tar.gz | tar -zxC $(DESTDIR)/bin/

binaries: $(DESTDIR)/bin/docker-machine-driver-kvm2
$(DESTDIR)/bin/docker-machine-driver-kvm2:
	mkdir -p $$(dirname $@)
	-$(download) https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2
	-chmod +x $@

binaries: $(DESTDIR)/bin/helm
$(DESTDIR)/bin/helm:
	mkdir -p $$(dirname $@)
	mkdir -p $(tempdir)/helm
	-$(curl) https://get.helm.sh/helm-v3.5.4-$(os)-$(goarch).tar.gz | tar -zx -C $(tempdir)/helm/
	-install -m 755 $(tempdir)/helm/$(os)-$(goarch)/helm $@
	rm -r $(tempdir)/helm

binaries: $(DESTDIR)/bin/pack
$(DESTDIR)/bin/pack:
	mkdir -p $$(dirname $@)
	-$(curl) https://github.com/buildpack/pack/releases/download/v0.18.1/pack-v0.18.1-$(os).tgz | tar -xzC $(DESTDIR)/bin/

binaries: $(DESTDIR)/bin/skaffold
$(DESTDIR)/bin/skaffold:
	mkdir -p $$(dirname $@)
	-$(download) https://storage.googleapis.com/skaffold/releases/v1.24.0/skaffold-$(os)-$(goarch)
	-chmod +x $@

binaries: $(DESTDIR)/bin/minishift
$(DESTDIR)/bin/minishift:
	mkdir -p $$(dirname $@)
	-$(curl) https://github.com/minishift/minishift/releases/download/v1.34.3/minishift-1.34.3-$(goos)-$(goarch).tgz | tar -xzC $(tempdir)
	-install -m 755 $(tempdir)/minishift-*/minishift $@
	-rm -r $(tempdir)/minishift-*

binaries: $(DESTDIR)/bin/oc
$(DESTDIR)/bin/oc:
	mkdir -p $$(dirname $@)
	-$(curl) https://github.com/openshift/okd/releases/download/4.7.0-0.okd-2021-04-24-103438/openshift-client-linux-4.7.0-0.okd-2021-04-24-103438.tar.gz | tar -xzC $(DESTDIR)/bin oc

binaries: $(DESTDIR)/bin/docker-machine-driver-kvm
$(DESTDIR)/bin/docker-machine-driver-kvm:
	mkdir -p $$(dirname $@)
	-$(download) https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-ubuntu16.04
	-chmod +x $@

binaries: $(DESTDIR)/bin/gomplate
$(DESTDIR)/bin/gomplate:
	mkdir -p $$(dirname $@)
	-$(download) https://github.com/hairyhenderson/gomplate/releases/download/v3.9.0/gomplate_$(goos)-$(goarch)
	-chmod +x $@

binaries: $(DESTDIR)/bin/envconsul
$(DESTDIR)/bin/envconsul:
	mkdir -p $$(dirname $@)
	-$(curl) https://releases.hashicorp.com/envconsul/0.11.0/envconsul_0.11.0_$(goos)_$(goarch).tgz | tar -xzC $$(dirname $@)
