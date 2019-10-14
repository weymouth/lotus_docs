.. manual-getting-started:

*****************
 Getting Started
*****************

* :ref:`required`
* :ref:`set-up`

.. _required:

####################
 Required software
####################

**Linux/Unix and Developer Tools**

Lotus needs to compile a small fortran script file at the start of every simulation. This is way too difficult to do with Windows machines. (``cmake`` is an option, but we don't recommend it.)

Ubuntu comes preloaded with ``git`` and ``make``.

OSX users should open the ``terminal`` app and type::

    $ git

At the prompt, you can download the developer tools.



**Dropbox**

Install `dropbox <https://www.dropbox.com>`_ and join the dropbox folder ‘repos’. These instruction assume the folder is located at ``~/Dropbox/repos/``



**Programming languages and libraries**

`gfortran <https://gcc.gnu.org/wiki/GFortranBinaries>`_ (v4.8+): The code is written in fortran, so you'll need a compiler. Check your version using::
    $ gfortran --version

`MPICH <http://www.mpich.org/downloads/>`_ : To run in parallel on a multi-core machine, you'll need to install this library.

`python <https://www.python.org/>`_ : We recommend doing all of the data-analysis and visualization in python. This can also be used to run a series of simulations and to update these documents.

`R-project <https://www.r-project.org/>`_ : An alternative data-analysis and visualization language. Some usefull libraries to install::

    $ sudo R
    > install.packages("ggplot2")
    > install.packages("dplyr")

**Additional Software**

`convert <http://www.imagemagick.org/script/convert.php>`_ (v6.9+): Convert is a cross platform library to create and manipulate images. It is required for the code to generate images during run-time.


`paraview <http://www.paraview.org/>`_ : The output binary file can be read and rendered using paraview.

`atom <https://atom.io/>`_ : This is a great text editor with lots of add-ons for efficient and easy coding such as the `language-fortran` package.


.. _set-up:

#############
 Setting up
#############

**Add Profile**

A profile file holds a list of shortcuts and adds things to your working ``PATH``.

If you're on Ubuntu::

    $ cp ~/Dropbox/repos/profile_ubuntu.txt ~/.profile
    $ atom ~/.bashrc

which will open the bach file. Add the lines::

    # read user scripts
    source ~/.profile

If you're on OSX::

    $ cp ~/Dropbox/repos/profile_osx.txt ~/.profile

In either case, you can now open a new terminal (which will automatically invoke the profile) or ``source`` it in the current terminal::

    $ source ~/.profile


**Clone Libraries**

Now you're ready to get Lotus. Make a Workspace folder and go into it::

    $ mkdir -p ~/Workspace/
    $ cd ~/Workspace

Clone the solver repositories::

    $ git clone -o dropbox ~/Dropbox/repos/solver
    $ cd solver
    $ git clone -o dropbox ~/Dropbox/repos/oop

Note than when you clone the solver, there will be a
separate README file in that folder. This file applies
to an old version of the code. You do not need to
follow those instructions for Lotus installation.

**Build Libraries**

This step is optional since running the Lotus will build the libraries automatically::

    $ cd ~/Workspace/solver/geom_lib
    $ make
    $ cd ../oop
    $ make

There should be no errors though possibily a few warnings.
