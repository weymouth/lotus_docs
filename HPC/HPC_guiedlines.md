# Resolution to block guidelines
## How it works
The way the the mpi works is by splitting the simulations into blocks and assigning a processor to those blocks. The processors then communicate with each other to simulate the whole domain.

## The problem
The problem to be addressed in this document is to determine whether there is an optimum number of grid points to assign to each block so as to use the HPC resources effectively.

## The process
To find an optimum solution 2D simulations will be run and compared to find whether there is a trend in communication time vs efficiency; where the efficiency is meassured using `seff <JOB_ID>` which is cputime /(runtime *cores).
The simulation will have Nx=512, Ny=320 so 163840 in total. The time step is kept constant.

## Results
The results of this test suggest that to reduce the time spent waiting for a simulation you should use as many blocks as the computer can handle. There is a limit however which was found when trying to use 2560 cells to a block. As a guidline the study worked best with 5120 cells to a block although this is not a strict limit.
What is strange is that as soon as the simulation has to run across 2 nodes it stops working...
