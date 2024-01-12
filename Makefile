ansible-local = ansible localhost -c local -i localhost, -e "ansible_python_interpreter=$$(which python3)"
ssh_configs != find ".ssh/config.d/" -type f \! -name '.*' | sort
curl = curl --location --silent --fail
download = $(curl) --output $@
mkd = mkdir -p $$(dirname $@)

.PHONY: all
all: secure-templates
all: ssh-keys
all: vendored

.PHONY: secure-templates
.PHONY: vendored

.PHONY: ssh-keys
ssh-keys: .ssh/gitlab_ed25519
ssh-keys: .ssh/gitlab_fdo_ed25519
ssh-keys: .ssh/gitlab_toptal_ed25519
ssh-keys: .ssh/github_ed25519
ssh-keys: .ssh/shore_ecdsa
ssh-keys: .ssh/shore_ed25519
ssh-keys: .ssh/shore_rsa
ssh-keys: .ssh/schoolinks_dev_rsa
ssh-keys: .ssh/schoolinks_ed25519
ssh-keys: .ssh/schoolinks_prod_rsa
ssh-keys: .ssh/schoolinks_rsa
ssh-keys: .ssh/schoolinks_stable_rsa
ssh-keys: .ssh/schoolinks_staging_rsa
ssh-keys: .ssh/schoolinks_qa_rsa

.ssh/%_rsa: Documents/Database.kdbx
	$(mkd)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

.ssh/%_ecdsa: Documents/Database.kdbx
	$(mkd)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

.ssh/%_ed25519: Documents/Database.kdbx
	$(mkd)
	ph show --field Notes "SSH/$$(basename '$@')" > '$@'
	chmod 600 '$@'

vendored: .config/pythonrc.py
.config/pythonrc.py: Makefile
	$(mkd)
	$(download) https://raw.githubusercontent.com/lonetwin/pythonrc/master/pythonrc_pre38.py

vendored: .local/bin/presentation
.local/bin/presentation: Makefile
	$(mkd)
	$(download) https://git.shore.co.il/nimrod/presentation/-/raw/master/presentation
	chmod +x '$@'

all: .local/bin/gm
.local/bin/gm: .local/bin/presentation
	ln -s presentation '$@'

all: .local/bin/pandoc
.local/bin/pandoc: .local/bin/presentation
	ln -s presentation '$@'

all: .local/bin/qpdf
.local/bin/qpdf: .local/bin/presentation
	ln -s presentation '$@'

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

templates != git ls-files -- '*.j2' | sed 's/\.j2$$//'
secure-templates: ${templates}
%: %.j2 Documents/Database.kdbx
	$(mkd)
	template '$<' > '$@'
	chmod 600 '$@'

secure-templates: .gnupg/trustdb.gpg
.gnupg/trustdb.gpg: Documents/Database.kdbx Makefile
	ph show --field 'Notes' 'GPG/D3B913DE36AB5565DCAC91C6A322378C61339ECD' | gpg --import
	echo 'D3B913DE36AB5565DCAC91C6A322378C61339ECD:6:' | gpg --import-ownertrust
	chmod 600 '$@'
