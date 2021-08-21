ansible-local = ansible localhost -c local -i localhost, -e "ansible_python_interpreter=$$(which python3)"
ssh_configs != find ".ssh/config.d/" -type f \! -name '.*' | sort
curl = curl --location --silent --fail
download = $(curl) --output $@
mkd = mkdir -p $$(dirname $@)

.PHONY: all
all: .ssh/gitlab_ed25519
all: .ssh/gitlab_fdo_ed25519
all: .ssh/gitlab_toptal_ed25519
all: .ssh/github_ed25519
all: .ssh/shore_ecdsa
all: .ssh/shore_ed25519
all: .ssh/shore_rsa
all: .ssh/smile_ed25519
all: .ssh/smile_rsa

.ssh/%_rsa: Documents/Database.kdbx
	$(mkd)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

.ssh/%_ed25519: Documents/Database.kdbx
	$(mkd)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

all: .config/pythonrc.py
.config/pythonrc.py:
	$(mkd)
	$(download) https://raw.githubusercontent.com/lonetwin/pythonrc/0.8.4/pythonrc.py

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

all: .gnupg/trustdb.gpg
.gnupg/trustdb.gpg: Documents/Database.kdbx
	ph show --field 'Notes' 'GPG/D3B913DE36AB5565DCAC91C6A322378C61339ECD' | gpg --import
	echo 'D3B913DE36AB5565DCAC91C6A322378C61339ECD:6:' | gpg --import-ownertrust
	chmod 600 '$@'

all: .bashrc.private
.bashrc.private: .bashrc.private.j2 Documents/Database.kdbx
	$(mkd)
	template '$<' > '$@'

all: .config/python-gitlab.cfg
.config/python-gitlab.cfg: .config/python-gitlab.cfg.j2 Documents/Database.kdbx
	$(mkd)
	template '$<' > '$@'

all: .config/gem/gemrc
.config/gem/gemrc: .config/gem/gemrc.j2 Documents/Database.kdbx
	$(mkd)
	template '$<' > '$@'

all: .bundle/config
.bundle/config: .bundle/config.j2 Documents/Database.kdbx
	$(mkd)
	template '$<' > '$@'

all: .aws/credentials
.aws/credentials: .aws/credentials.j2 Documents/Database.kdbx
	$(mkd)
	template '$<' > '$@'
