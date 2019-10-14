.. _manual-running-simulations:

*********************
 Running Simulations
*********************

* :ref:`sample`
* :ref:`runLotus`

.. _sample:

**************
Sample Project
**************

To get started, lets just trying running a sample project on a single processor. To do so, create a working directory and then copy the sample sphere project into it::

    $ mkdir -p ~/Workspace/projects/sphere
    $ tar -xvf ~/Dropbox/repos/sphere.tgz -C ~/Workspace/projects/sphere

Now you can try running the sphere program::

    $ cd ~/Workspace/projects/sphere
    $ runLotus 0 test

The ``runLotus`` command invokes a script file which we will consider in more detail later. For now, know that it updates the libraries (if you haven't built them yet, this may take a while) and then it runs `Lotus` in the `test` folder.

As this is happening, what you should see in the terminal window is:

.. literalinclude:: terminal.txt

.. _runLotus:

****************
runLotus Script
****************

Before moving on, lets take a closer look at the `runLotus` script, its inputs and options. The script is found in `solver\oop\bin`. The script is invoked as

.. code-block:: shell

  $ runLotus <n> <run_folder> <resume_path>

where

- ``n`` (int): number of processors

    * If running in serial this should be 0 and the solver should be recompiled commenting out 'MPI = true' in the lotus profile.
    * If running in parallel the available/desired number of processors should be given. The solver should also be compiled for parallel simulations.
- ``run_folder`` (string): name of the folder in which to run the simulation

- ``resume_path`` (optional, string): path from `run_folder` to the folder from which to resume the simulation

    * If not included, the simulation will run without resuming from a previous simulation.
    * If set to ``./``, the simulation will resume from the `run_folder` if possible.
    * Otherwise, the simulation will follow `resume_path` and attempt to resume from there.

For example:

.. code-block:: shell

  $ runLotus 16 test ../test_old/

will run a simulation in the test folder on 16 cores, resuming from test_old.

The runLotus script does a few important things:

- It checks if `run_folder` exists. If so, and there is no `resume_path`, it moves the contents of the folder to the trash folder. If not, it makes the folder.
- It copies the `lotus.f90 file` and the contents of the postproc folder into `run_folder`.
- It changes into the run_folder and creates the executable, updating and building the libraries as needed.
- Finally, it runs the executable, and then the runStatus script upon completion.
