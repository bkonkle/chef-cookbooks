==================
Installation
==================

Pre-Requisites
===============

* `setuptools <http://pypi.python.org/pypi/setuptools>`_
* `virtualenv <http://pypi.python.org/pypi/virtualenv>`_

To install all of these system dependencies on a Debian-based system, run::

	sudo apt-get install python-setuptools
	sudo easy_install virtualenv


Creating the Virtual Environment
================================

First, create a clean base environment using virtualenv::

    virtualenv example_project
    cd example_project
    source bin/activate


Installing the Project
======================

Install the requirements and the project source::

	cd path/to/your/example_project/repository
    pip install -r requirements.pip
    pip install -e .


Configuring a Local Environment
===============================

If you're just checking the project out locally, you can copy some example
configuration files to get started quickly::

    cp example_project/conf/local/example/* example_project/conf/local
    manage.py syncdb --migrate


Building Documentation
======================

Documentation is available in ``docs`` and can be built into a number of 
formats using `Sphinx <http://pypi.python.org/pypi/Sphinx>`_. To get started::

    pip install Sphinx
    cd docs
    make html

This creates the documentation in HTML format at ``docs/_build/html``.
