rcfiles
*******

.. image:: https://travis-ci.org/adarnimrod/rcfiles.svg?branch=master
    :target: https://travis-ci.org/adarnimrod/rcfiles

A repository with my rc files. The purpose is for me to have revision control of
my home directory, maybe send somebody a link to an example file and to be
browsable for others (if anyone wants to copy some snippet). Because these are
my actual files that I use right now, the repository is cloned directly to my
home directory and is not meant for mass consumption as it is.

Usage
-----

WARNING: This will overwrite your existing files.

.. code:: shell

    cd
    git clone --bare https://www.shore.co.il/git/rcfiles .git
    sed -i '/bare/d' .git/config
    git reset --hard
    git bull
    Documents/bin/install-git-hooks

License
-------

This software is licensed under the MIT license (see the :code:`LICENSE.txt`
file).

Author Information
------------------

Nimrod Adar, `contact me <nimrod@shore.co.il>`_ or visit my `website
<https://www.shore.co.il/>`_. Patches are welcome via `git send-email
<http://git-scm.com/book/en/v2/Git-Commands-Email>`_. The repository is located
at: https://www.shore.co.il/git/.
