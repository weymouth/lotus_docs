.. _manual-simulations-parallel-simulations:

**********************
 Parallel Simulations
**********************

Running parallel simulations in Lotus is prety easy. The snipet of code below shows the relevant parts of a parallel simulation.

.. literalinclude:: parallel.f90
    :language: fortran
.. literalinclude:: parallel2.f90
    :language: fortran
.. literalinclude:: parallel3.f90
    :language: fortran

To run parallel simulations the midle block should be changed to the one below.

.. literalinclude:: parallel2_3d.f90
    :language: fortran

The main difference is in telling the MPI initialiser that the simulation is in three dimensions.

Also, but this may not always be the case, that the flow through the the Z direction is repeated periodically by a distance equal to the domain. That is that flow that leaves the top Z boundary enters the domain again at the bottom Z.  
