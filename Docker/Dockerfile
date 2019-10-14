FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    gfortran \
    libopenmpi-dev \
    openmpi-bin \
    imagemagick \
    time\
 && rm -rf /var/lib/apt/lists/* \
 && ulimit -s unlimited

ENV	MGLHOME='/app/solver' \
	PROJ_DIR='/app/projects'
ENV	PATH=$PATH:$MGLHOME'/bin':$MGLHOME'/oop/bin' \
	MPI='true' \
	F90='gfortran' \
	open='xdg-open' \
	trash='rm -rf' \
	# For MCA problem. See: https://github.com/open-mpi/ompi/issues/4948
	OMPI_MCA_btl_vader_single_copy_mechanism='none' 

COPY solver $MGLHOME

RUN cd $MGLHOME/geom_lib \
 && make \
 && cd $MGLHOME/oop \
 && make

VOLUME $PROJ_DIR
WORKDIR $PROJ_DIR

ENTRYPOINT ["/bin/bash", "runLotus"]
