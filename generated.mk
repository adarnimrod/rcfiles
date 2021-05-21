DESTDIR ?= .local
ansible-local = ansible localhost -c local -i localhost, -e "ansible_python_interpreter=$$(which python3)"
ssh_configs != find ".ssh/config.d/" -type f \! -name '.*' | sort

.PHONY: generated
all: generated

generated: .bash_completion.d/helm
.bash_completion.d/helm: $(DESTDIR)/bin/helm
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

generated: .bash_completion.d/kompose
.bash_completion.d/kompose: $(DESTDIR)/bin/kompose
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

generated: .bash_completion.d/kops
.bash_completion.d/kops: $(DESTDIR)/bin/kops
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

generated: .bash_completion.d/kubectl
.bash_completion.d/kubectl: $(DESTDIR)/bin/kubectl
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

generated: .bash_completion.d/minikube
.bash_completion.d/minikube: $(DESTDIR)/bin/minikube
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

generated: .bash_completion.d/skaffold
.bash_completion.d/skaffold: $(DESTDIR)/bin/skaffold
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

generated: .bash_completion.d/pipenv
.bash_completion.d/pipenv:
	mkdir -p $$(dirname $@)
	-bash -c 'pipenv --completion > $@'

generated: .bash_completion.d/pandoc
.bash_completion.d/pandoc:
	mkdir -p $$(dirname $@)
	-pandoc --bash-completion > $@

generated: .bash_completion.d/rabbitmqadmin
.bash_completion.d/rabbitmqadmin: Documents/bin/rabbitmqadmin
	mkdir -p $$(dirname $@)
	-Documents/bin/rabbitmqadmin --bash-completion > $@

generated: .bash_completion.d/minishift
.bash_completion.d/minishift: $(DESTDIR)/bin/minishift
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

generated: .bash_completion.d/oc
.bash_completion.d/oc: $(DESTDIR)/bin/oc
	mkdir -p $$(dirname $@)
	-$$(basename $@) completion bash > $@

generated: .bash_completion.d/poetry
.bash_completion.d/poetry:
	-poetry completions bash > $@

generated: .bashrc.private
.bashrc.private: Documents/Database.kdbx
	echo "export GITLAB_TOKEN='$$(ph show --field Password 'shore.co.il/GitLab token')'" > '$@'

generated: .ssh/github_ed25519
.ssh/github_ed25519: Documents/Database.kdbx
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

generated: .ssh/gitlab_fdo
.ssh/gitlab_fdo: Documents/Database.kdbx
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

generated: .ssh/gitlab_toptal
.ssh/gitlab_toptal: Documents/Database.kdbx
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

generated: .ssh/shore_rsa
.ssh/shore_rsa: Documents/Database.kdbx
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

generated: .ssh/gitlab_ed25519
.ssh/gitlab_ed25519: Documents/Database.kdbx
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

generated: .ssh/shore_ecdsa
.ssh/shore_ecdsa: Documents/Database.kdbx
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

generated: .ssh/shore_ed25519
.ssh/shore_ed25519: Documents/Database.kdbx
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

generated: .ssh/config
.ssh/config: $(ssh_configs)
	mkdir -p $$(dirname $@)
	cat $(ssh_configs) > $@

generated: .ssh/localhost
.ssh/localhost:
	-rm $@ $@.pub
	ssh-keygen -t ecdsa -N '' -C localhost -f $@

generated: .ssh/localhost.pub
.ssh/localhost.pub: .ssh/localhost
	ssh-keygen -y -f $< > $@

generated: .ssh/authorized_keys
.ssh/authorized_keys: .ssh/localhost.pub
	-$(ansible-local) -m authorized_key -a "user=$$(whoami) key='$$(cat .ssh/localhost.pub)' key_options='from=\"127.0.0.1/8\"'"
