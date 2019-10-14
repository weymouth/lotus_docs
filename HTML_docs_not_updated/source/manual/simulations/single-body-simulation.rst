.. _manual-multi-body-simulation:

************************
 Single Body Simulation
************************

The Lotus solver interacts between two types of objects. A type 'body' and a type 'fluid'. The 'body' holds the geometry and its mappings. The 'fluid' defines a fluid type, which contains the velocity and pressure fields, along with the Poisson solver data.

In order to carry out Single Body Simulations (SBS), one must create a type 'body', which contains the one of geometries found in 'geom_lib/analitic.f90'.
