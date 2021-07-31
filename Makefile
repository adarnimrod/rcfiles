ansible-local = ansible localhost -c local -i localhost, -e "ansible_python_interpreter=$$(which python3)"
ssh_configs != find ".ssh/config.d/" -type f \! -name '.*' | sort
curl = curl --location --silent --fail
download = $(curl) --output $@
mkd = mkdir -p $$(dirname $@)

.PHONY: all
all: .ssh/gitlab_ed25519
all: .ssh/gitlab_fdo
all: .ssh/gitlab_toptal
all: .ssh/github_ed25519
all: .ssh/shore_ecdsa
all: .ssh/shore_ed25519
all: .ssh/shore_rsa
all: .ssh/smile_ed25519
all: .ssh/smile_rsa

.ssh/%: Documents/Database.kdbx
	$(mkd)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

# Disable the implicit rule above so that other files under .ssh/ will be
# created using an explicit rule.
.ssh/%: Documents/Database.kdbx

all: .config/pythonrc.py
.config/pythonrc.py:
	$(mkd)
	$(download) https://raw.githubusercontent.com/lonetwin/pythonrc/0.8.4/pythonrc.py

all: .bashrc.private
.bashrc.private: Documents/Database.kdbx
	echo "export GITLAB_TOKEN='$$(ph show --field Password 'shore.co.il/GitLab token')'" > '$@'
	echo 'export GITLAB_PRIVATE_TOKEN="$$GITLAB_TOKEN"' >> '$@'
	echo "export GITLAB_REGISTRATION_TOKEN='$$(ph show --field Password 'shore.co.il/GitLab runner registration token')'" >> '$@'
	echo "export GITHUB_TOKEN='$$(ph show --field 'CLI token' 'Web Sites/GitHub')'" >> '$@'

all: .ssh/config
.ssh/config: $(ssh_configs)
	$(mkd)
	cat $(ssh_configs) > $@

all: .ssh/localhost
.ssh/localhost:
	$(mkd)
	-rm $@ $@.pub
	ssh-keygen -t ecdsa -N '' -C localhost -f $@

all: .ssh/localhost.pub
.ssh/localhost.pub: .ssh/localhost
	$(mkd)
	ssh-keygen -y -f $< > $@

all: .ssh/authorized_keys
.ssh/authorized_keys: .ssh/localhost.pub
	$(mkd)
	-$(ansible-local) -m authorized_key -a "user=$$(whoami) key='$$(cat .ssh/localhost.pub)' key_options='from=\"127.0.0.1/8\"'"

all: .config/python-gitlab.cfg
.config/python-gitlab.cfg: Documents/Database.kdbx
	$(mkd)
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
	$(mkd)
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

all: .aws/credentials
.aws/credentials: Documents/Database.kdbx
	$(mkd)
	echo '[shore]' > '$@'
	echo "aws_access_key_id = $$(ph show --field 'UserName' 'shore.co.il/AWS CLI')" >> '$@'
	echo "aws_secret_access_key = $$(ph show --field 'Password' 'shore.co.il/AWS CLI')" >> '$@'
	echo '' >> '$@'
	echo '[smile]' > '$@'
	echo "aws_access_key_id = $$(ph show --field 'UserName' 'Smile/AWS CLI')" >> '$@'
	echo "aws_secret_access_key = $$(ph show --field 'Password' 'Smile/AWS CLI')" >> '$@'

all: .gnupg/trustdb.gpg
.gnupg/trustdb.gpg: Documents/Database.kdbx
	ph show --field 'Notes' 'GPG/D3B913DE36AB5565DCAC91C6A322378C61339ECD' | gpg --import
	echo 'D3B913DE36AB5565DCAC91C6A322378C61339ECD:6:' | gpg --import-ownertrust
	chmod 600 '$@'
