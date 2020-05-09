# rcfiles

[![image](https://travis-ci.org/adarnimrod/rcfiles.svg?branch=master)](https://travis-ci.org/adarnimrod/rcfiles)

A repository with my rc files. The purpose is for me to have revision
control of my home directory, maybe send somebody a link to an example
file and to be browsable for others (if anyone wants to copy some
snippet). Because these are my actual files that I use right now, the
repository is cloned directly to my home directory and is not meant for
mass consumption as it is.

## Installation

*WARNING: This will overwrite your existing files.*

    cd
    git init
    git remote add origin https://www.shore.co.il/git/rcfiles
    git fetch
    git reset --hard origin/master
    git branch --set-upstream-to=origin/master
    git bull
    Documents/bin/install-git-hooks
    .githooks/post-merge

## Dependencies

Dependencies that can be installed locally inside the home directory, are
installed with the Git hook using the supplied `Makefile`. Dependencies that
can't be installed locally, can be install with the `workstation.yml` Ansible
playbook from the
[ansible-desktop-playbook](https://www.shore.co.il/git/ansible-desktop-playbooks)
repository, please consult the README from that repository. Care has been given
to minimizing the dependencies and making the scripts as cross-platform as
reasonably possible, so most script would run without any installing any tools
not found on a Unix-like OS by default.

## License

This software is licensed under the MIT license (see `LICENSE.txt`).

## Author Information

Nimrod Adar, [contact me](mailto:nimrod@shore.co.il) or visit my [website](
https://www.shore.co.il/). Patches are welcome via [`git send-email`](
http://git-scm.com/book/en/v2/Git-Commands-Email). The repository is located
at: <https://www.shore.co.il/git/>.
