Cleanup scripts
***************

Clean and update scripts for Vagrant boxes and instances and Docker images and
containers.

Usage
-----

The update scripts download new boxes/ images, the Vagrant clean scripts removes
old version of base boxes (if newer ones are present) and the Docker clean
script removes exited or created containers and dangling images.

Requirements
------------

Obviously Docker and Vagrant respectfuly, also Python and the :code: `sh` and
:code: `parse` Python packages for the Vagrant scripts.
