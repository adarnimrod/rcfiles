# rcfiles

[![pipeline status](https://git.shore.co.il/nimrod/rcfiles/badges/master/pipeline.svg)](https://git.shore.co.il/nimrod/rcfiles/-/commits/master)

A repository with my rc files and various scripts I have. The purpose is for me
to have revision control of my home directory, maybe send somebody a link to an
example file and to be browsable for others (if anyone wants to copy some
snippet). Because these are my actual files that I use right now, the repository
is cloned directly to my home directory and is not meant for mass consumption as
it is.

## Installation

*WARNING: This will overwrite your existing files.*

```
cd
git init
git remote add origin https://git.shore.co.il/nimrod/rcfiles.git/
git fetch
git reset --hard origin/master
git branch --set-upstream-to=origin/master
git bull
Documents/bin/install-git-hooks
.githooks/post-merge
```

## Dependencies

Care has been taken to make the scripts as portable as possible. Meaning that
they should work out of the box on Debian, Alpine and OpenBSD. This is a
best-effort on my part so mistake are made, feel free to send patches. The
counterpart for this repository is the
[workbench](https://git.shore.co.il/shore/workbench) project where I maintain a
container image with all of the tools I use, but that is for Linux only.

## License

This software is licensed under the MIT license (see `LICENSE.txt`).

## Author Information

Nimrod Adar, [contact me](mailto:nimrod@shore.co.il) or visit my
[website](https://www.shore.co.il/). Patches are welcome via
[`git send-email`](http://git-scm.com/book/en/v2/Git-Commands-Email). The repository
is located at: <https://git.shore.co.il/explore/>.
