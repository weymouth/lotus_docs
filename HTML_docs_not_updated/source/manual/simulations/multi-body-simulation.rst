.. _manual-simulations-multi-body-simulation:

***********************
 Multi Body Simulation
***********************

The Lotus solver interacts between two types of objects. A type 'body' and a type 'fluid'. The 'body' holds the geometry and its mappings. The 'fluid' defines a fluid type, which contains the velocity and pressure fields, along with the Poisson solver data.

In order to carry out Multi Body Simulations (MBS), one must create a type 'set', which contains the various geometries.

The mapping .or. , similar to the AND logical operator, allows the user to combine predefined geometries together, which are found in 'geom_lib/analitic.f90'.


1. Create a type 'set'
2. Initiate the 'set' with one of the predefined geometries
3. Add predefined geometries until obtained the required geometry.
4. Assign the 'set' to the type 'body'


One of the advantages of Lotus's mapping system is that one can for example use the .and. mapping to obtain the opposite result. That is that the resultant geometry is the intersection of two or more geometries.

Relevant files within the repos directory:

* oop/body.f90
* oop/fluid.f90
* geom_lib/analitic.f90
* geom_lib/map.f90
