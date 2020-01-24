********************************************************************************************************
* Instructions to run Lotus in the Iridis4 cluster                                                     *
********************************************************************************************************

CREATE AND ACCOUNT AND LOGIN

  Create an account if you do not have an active account yet:

    http://www.southampton.ac.uk/isolutions/forms/iridis-account.page

  Login to Iridis via ssh with an activated account when connected to the university network or VPN:

  $ ssh -x <username>@iridis4_a.soton.ac.uk

_______________________________________________________________________________________________________

PULL LOTUS SOLVER FROM GITHUB

  Once accessed to the login node you will be in a remote terminal.
  First, create a folder for Lotus directory:

  $ mkdir ~/Lotus

  Now get in that directory and pull the latest version of the geom and fluid libraries from Github. Make sure you are
  added as a collaborator these repositories (ask Gabe) or you won't be able to access them.

  $ cd ~/Lotus
  $ git clone https://<github-username>:<github-password>@github.com/weymouth/lotus_geom_lib.git solver
  $ cd solver
  $ git clone https://<github-username>:<github-password>@github.com/weymouth/lotus_oop.git oop

  The clone command pulls the 'master' branch by default. To access any other branch just use
  $ cd oop
  $ git checkout <branch-name>

  And this will pull the branch, checkout into it, and track the remote branch.
_______________________________________________________________________________________________________

CONFIGURE YOUR BASH PROFILE

  In order to run Lotus the bash profile needs to be amended and the linux .profile script sourced
  into your ~/.bash_profile

  Create the linux .profile Lotus script (almost same as profile_ubuntu.txt for which only the first
  line needs to be modified):

  $ cd
  $ nano .profile

    export MGLHOME=$HOME'/Lotus/solver'
    export PATH=$PATH:$MGLHOME/bin:$MGLHOME/oop/bin
    export MPI='true'
    export F90='gfortran'
    alias open='xdg-open'
    ulimit -s unlimited
    alias trash='gvfs-trash'

  Save this file with
   ctrl+o
   ctrl+x

  (You can also scp your local .profile and just modify the first line as above).

  Edit the ~/.bash_profile script to source the new .profile

  $ nano .bash_profile

  Add the following lines

    # Source your linux .profile
    if [ -f ~/.profile ]; then
        . ~/.profile
    fi

  Save the file as before.

  To update the ~/.bash_profile for the current log in session you need to source the profile in the command line.

  $ source ~/.bash_profile

  You don't need to do this every time you log in to iridis. Now you should be good to compile and run Lotus.

  _______________________________________________________________________________________________________

  LOAD THE REQUIRED MODULES AND COMPILE LOTUS

    The module required to run Lotus are: R, gcc, openmpi. They can be loaded into your login node as:

    $ module purge
    $ module load binutils/2.26
    $ module load R/3.3.0
    $ module load openmpi/1.10.6/gcc
    $ module load gcc/6.1.0

    In order to avoid problems with the openmpi library (mpi.mod), the FC (Fortran compiler) environment
    variable needs to be exported as:

    $ export FC=gcc-6.1.0

    Otherwise the openmpi Fortran compiler (mpif90) will complain regarding the GNU Fortran version.
    Also note that the last module to be uploaded is gcc/6.1.0 to override the default gcc module loaded
    with openmpi.

    Now go to your ~/Lotus/solver/geom_lib/ and ~/Lotus/solver/oop/ folder and try to compile the code:

    $ cd ~/Lotus/solver/geom_lib/
    $ make clean
    $ make
    $ cd ~/Lotus/solver/oop/
    $ make clean
    $ make

    If the mpi.mod library gives trouble is probably because the openmpi module has been loaded before
    the gcc module. To solve it try:

    $ make clean
    $ module unload openmpi/1.10.6/gcc
    $ module load openmpi/1.10.6/gcc
    $ make

  _______________________________________________________________________________________________________

  RUN YOUR LOTUS TEST SIMULATION INTO THE LOGIN NODES

  Before running, the openmpi module which compiles lotus.f90 needs to be changed to version 1.8.3 since version
  1.10.6 can be problematic (see * link). The best way to do this is to purge and load the modules again:

  $ module purge
  $ module load binutils/2.26
  $ module load R/3.3.0
  $ module load openmpi/1.8.3/gcc
  $ module load gcc/6.1.0

  Now you can give it a try in the login node (a very short simulation, just to see that it runs correctly).
  To do so, add a /projects folder into the ~/Lotus/ folder previously created and scp a valid lotus.f90 file).

  $ mkdir ~/Lotus/projects/
  $ mkdir ~/Lotus/projects/project1/

  scp here you lotus.f90 file, eg:
  
  $ scp lotus.f90 <username>@iridis4_a.soton.ac.uk:~/Lotus/projects/project1

  Run Lotus as usual, eg:

  $ runLotus 4 test
_______________________________________________________________________________________________________

SUBMIT YOUR LOTUS SIMULATION INTO THE COMPUTATIONAL NODES

  Once the compilation and the execution of Lotus has succeed you are good to submit your Lotus
  simulation into the computational nodes. To do so, a submission file is required.
  Have a look at the subLotus file and familiarize with the submission commands.

  Remember that the number of processors specified in the lotus.f90 (blocs) and at the runnining command
  (subLotus last line) must be the same as the number of processors specified at the #PBS variable of the
  subLotus file. Eg:

    lotus.f90:

        integer :: b(3) = (/8,4,2/)   ! Blocks. Product = number of processors.

    subLotus:

    	#PBS -l nodes=4:ppn=16
    	# Remember that Iridis has 2 processors per nodes with 8 cores per processor = 16 processor cores per node

    	runLotus 64 test


  Now, scp subLotus to ~/Lotus/projects/project1/ and modify with your own preferences.

  Submit the job:

    $ qsub subLotus

  Note: The qsub command will not work if you have loaded 'module purge' into the command line or your ~/.bash_profile.
        To rectify this simply log out and log back in to iridis, making sure that you are not loading 'module purge'
        in your ~/.bash_profile.

  Output data will be found in the folder specified in the subLotus file.
  Useful information about Iridis (job submissions, queues, forums, etc) can be found in:

      https://hpc.soton.ac.uk/community/projects/iridis/wiki
  (*) https://hpc.soton.ac.uk/community/boards/1/topics/7832?r=7861#message-7861
