rcfiles
*******

A repository with my rc files. The purpose is for me to have revision control of
my home directory, maybe send somebody a link to an example file and to be
browsable for others (if anyone wants to copy some snippet). Because these are
my actual files that I use right now, the repository is cloned directly to my
home directory and is not meant for mass consumption as it is.

Usage
-----

WARNING: This will overwrite your existing files.

.. code:: shell

    git clone https://www.shore.co.il/git/rcfiles
    cd rcfiles
    mv -f $(ls -A) $HOME/
    cd ..
    rm -r rcfiles
    git submodule update --init --recursive

In older versions of Git the paths in the submodules are obsolete and thus need
to be corrected (before fetching them). The correction needs to be done in the
:code:`.git` and :code:`config` files inside each submodule.

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
