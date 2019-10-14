**1.** [Install Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

**2.** [Manage Docker as a non-root user](https://docs.docker.com/install/linux/linux-postinstall/)

Note that the files created during the simulation will still have root privileges. These may need to be restored to user privileges for post-processing reasons as explained in the remarks.

**3.** Test Docker: 
```
docker run hello-world
```

**4.** Pull the Docker image based on Ubuntu which contains the Lotus solver (you need to be added as collaborator in the Docker Hub repository, send me an [email](mailto:b.fontgarcia@soton.ac.uk))

```
docker login --username your_username
docker pull bfont/lotus
```

**5.** Create a working directory and the required subdirectories

```
mkdir $HOME/Workspace/docker/Lotus
mkdir $HOME/Workspace/docker/Lotus/bin
mkdir $HOME/Workspace/docker/Lotus/projects
```

**6.** Add the following lines (environmental variables) in `~/.profile`:

```
export LOCAL_LOTUS_DIR=$HOME'/Workspace/docker/Lotus'
export LOCAL_PROJ_DIR=$LOCAL_LOTUS_DIR'/projects'
export DOCKER_PROJ_DIR='/app/projects'
export PATH=$PATH:$LOCAL_LOTUS_DIR/bin
```

**7.** Source `~/.profile` in `~/.bashrc` adding the following line in `~/.bashrc`:

```
. ~/.profile
```

**8.** Copy from Dropbox or pull from GitHub (again, send me an [email](mailto:b.fontgarcia@soton.ac.uk)) the following scripts: `runDocker`, `Dockerfile`,`lotus.f90`, `runStat` . With `git`:

```
git clone https://github.com/b-fg/Lotus-docker.git $LOCAL_LOTUS_DIR
```
Now put them in the relevant directory. It should look like this:
```
$LOCAL_LOTUS_DIR/
    lotus.f90
    stat.py
    bin/
        runDocker
        runStat
    projects/
```

The script `runDocker` is a wrap around `docker run`, which function is to create a container from the Docker image you have just pulled. Also, `runDocker` passes the arguments normally used with `runLotus` to the Docker container and launches `runStat` if the `stat.py` python is present. The script `runStat` takes care of actually running `stat.py`, which finally provides the post-processing results. 

The `Dockerfile` script is the "Docker Makefile" that have been used to create the `bfont/lotus` image. You do not need this script for running the simulations, but it is informative to have a look and see how the Lotus docker image is created. Ultimatelly, the image is created using the command: `docker build -t bfont/lotus .`

**9.** Run a simulation using the `lotus.f90` script in the Lotus folder with the `runDocker` bash script:

```
runDocker 4 test1
```

**10.** Run again restarting from `test1`

```
runDocker 4 test2 test1
```

**11.** Remarks:

- When using `runDocker`, the specified project folder will always be located in `$LOCAL_LOTUS_DIR/projects`.
- If you are restarting from another simulation, for example `test1`,  this needs to be located in `$LOCAL_LOTUS_DIR/projects`.
- Even after following step **2**, the project folders will always have root privileges. To be able to run the post-processing python script, you will need to introduce your root password to change that folder privilages after the simulation finishes (this change of privileges is called from the runDocker script using `sudo chown -R $USER:$USER $LOCAL_PROJ_DIR/project_directory`). If you fail to do so (long simulation not paying attention at when it finishes), no worries - you can do it manually afterwards with

```
  $ sudo chown -R $USER:$USER $LOCAL_PROJ_DIR/project_directory
  $ cd $LOCAL_PROJ_DIR/project_directory
  $ cp $LOCAL_LOTUS_DIR/stat.py .
  runStat
```