# Using Singularity, the container-based platform for HPC systems

Because Docker requires root privileges to run on systems, it is not possible to use in clusters. Therefore, an alternative container-based platform is required to run it in HPC systems. This is [Singularity](https://singularity.lbl.gov/) and here it is explained how to use Lotus in Iridis5 through this app. This is very useful so you can avoid the troubles of using different OpenMPI version for build/run. 

Note that it is not possible to run the current Lotus image through Singularity on Iridis4 since the image is built on top of Ubuntu 18.04, which uses a more recent Linux kernel than the latest available in Iridis4.

To run Lotus through Singularity on Iridis5 follow the next steps.

**1.** Connect to Iridis5 and create a folder for Lotus in your home directory (if you do not have it already):

```
ssh username@iridis5_b.soton.ac.uk
mkdir -p Lotus/bin
```

**2.** In the `~/Lotus/bin` director, download and build the Lotus Docker image as a Singularity image (you need to be added as collaborator in the Docker Hub repository, send me an [email](mailto:b.fontgarcia@soton.ac.uk)):

```
cd ~/Lotus/bin
export SINGULARITY_DOCKER_USERNAME=docker_username
export SINGULARITY_DOCKER_PASSWORD=docker_password
module load singularity
singularity build lotus.sif docker://bfont/lotus
```

**3.** Copy the `runSingularity` script into the `~/Lotus/bin` directory. It should now contain the `runSingularity` script and the `lotus.sif` Singularity image. The `runSingularity` script needs execution permissions, so set them with:
```
chmod +x runSingularity
```

**4.** Add the following lines (environmental variables) in `~/.bash_profile`:

```
export LOCAL_LOTUS_DIR=$HOME'/Lotus'
export LOTUS_BIN=$LOCAL_LOTUS_DIR'/bin'
export LOCAL_PROJ_DIR='/scratch/'$USER'/Lotus'
export DOCKER_PROJ_DIR='/app/projects'
export PATH=$PATH:$LOTUS_BIN
```

**5.** Source again the `~/.bash_profile` script typing `. ~/.bash_profile` in the terminal.

**6.** Create a project folder in `~/Lotus` such as `test`. Include in `~/Lotus/test` the provided `subLotus` script and a `lotus.f90` file you would like to run.

**7.** Edit the `subLotus` submission script to meet your `lotus.f90` requirements (such as number of processes), walltime, etc. The line that calls the `runSingularity` script to run the Singularity image (which includes the Lotus solver) is the last line of the subimission script:
```
runSingularity $SLURM_NTASKS test
```
Specify the folder where Lotus will place the output, in this case `test`. The script `runSingularity` automatically places this folder in your `scratch` directory. Check the script for more info. You can specify a restarting folder as normally with:
```
runSingularity $SLURM_NTASKS test2 test
```
Where the restarting folder has to be located in the `/scratch/$USER/Lotus/test`directory.

**8.** The job can be finally submitted from the `~/Lotus/test` directory as follows:
```
cd ~/Lotus/test
sbatch subLotus
```
and results will be placed in the `/scratch/$USER/Lotus` directory.