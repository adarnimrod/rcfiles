DESTDIR ?= .local
ansible-local = ansible localhost -c local -i localhost, -e "ansible_python_interpreter=$$(which python3)"
ssh_configs != find ".ssh/config.d/" -type f \! -name '.*' | sort

all: .config/pythonrc.py
.config/pythonrc.py:
	mkdir -p $$(dirname $@)
	$(download) https://raw.githubusercontent.com/lonetwin/pythonrc/0.8.4/pythonrc.py

all: .bashrc.private
.bashrc.private: Documents/Database.kdbx
	echo "export GITLAB_TOKEN='$$(ph show --field Password 'shore.co.il/GitLab token')'" > '$@'
	echo 'export GITLAB_PRIVATE_TOKEN="$$GITLAB_TOKEN"' >> '$@'
	echo "export GITLAB_REGISTRATION_TOKEN='$$(ph show --field Password 'shore.co.il/GitLab runner registration token')'" >> '$@'
	echo "export GITHUB_TOKEN='$$(ph show --field 'CLI token' 'Web Sites/GitHub')'" >> '$@'

all: .ssh/github_ed25519
.ssh/github_ed25519: Documents/Database.kdbx
	mkdir -p $$(dirname $@)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

all: .ssh/gitlab_fdo
.ssh/gitlab_fdo: Documents/Database.kdbx
	mkdir -p $$(dirname $@)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

all: .ssh/gitlab_toptal
.ssh/gitlab_toptal: Documents/Database.kdbx
	mkdir -p $$(dirname $@)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

all: .ssh/shore_rsa
.ssh/shore_rsa: Documents/Database.kdbx
	mkdir -p $$(dirname $@)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

all: .ssh/gitlab_ed25519
.ssh/gitlab_ed25519: Documents/Database.kdbx
	mkdir -p $$(dirname $@)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

all: .ssh/shore_ecdsa
.ssh/shore_ecdsa: Documents/Database.kdbx
	mkdir -p $$(dirname $@)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

all: .ssh/shore_ed25519
.ssh/shore_ed25519: Documents/Database.kdbx
	mkdir -p $$(dirname $@)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

all: .ssh/config
.ssh/config: $(ssh_configs)
	mkdir -p $$(dirname $@)
	cat $(ssh_configs) > $@

all: .ssh/localhost
.ssh/localhost:
	mkdir -p $$(dirname $@)
	-rm $@ $@.pub
	ssh-keygen -t ecdsa -N '' -C localhost -f $@

all: .ssh/localhost.pub
.ssh/localhost.pub: .ssh/localhost
	mkdir -p $$(dirname $@)
	ssh-keygen -y -f $< > $@

all: .ssh/authorized_keys
.ssh/authorized_keys: .ssh/localhost.pub
	mkdir -p $$(dirname $@)
	-$(ansible-local) -m authorized_key -a "user=$$(whoami) key='$$(cat .ssh/localhost.pub)' key_options='from=\"127.0.0.1/8\"'"

all: .config/python-gitlab.cfg
.config/python-gitlab.cfg: Documents/Database.kdbx
	mkdir -p $$(dirname $@)
	echo '[global]' > '$@'
	echo 'default = shore.co.il' >> '$@'
	echo 'ssl_verify = true' >> '$@'
	echo '' >> '$@'
	echo '[shore.co.il]' >> '$@'
	echo 'url = https://git.shore.co.il/' >> '$@'
	echo "private_token = $$(ph show --field Password 'shore.co.il/GitLab token')" >> '$@'
	echo 'api_version = 4' >> '$@'

all: .config/gem/gemrc
.config/gem/gemrc: Documents/Database.kdbx
	mkdir -p $$(dirname $@)
	echo '# vim: ft=yaml' > '$@'
	echo '---' >> '$@'
	echo ':backtrace: false' >> '$@'
	echo ':bulk_threshold: 1000' >> '$@'
	echo ':sources:' >> '$@'
	echo '- https://rubygems.org/' >> '$@'
	echo "- https://$$(ph show --field 'UserName' 'Web Sites/GitHub'):$$(ph show --field 'Smile gem token' 'Web Sites/GitHub')@rubygems.pkg.github.com/smile-io/" >> '$@'
	echo ':update_sources: true' >> '$@'
	echo ':verbose: true' >> '$@'
	echo ':concurrent_downloads: 8' >> '$@'
