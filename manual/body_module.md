# body.f90 notes and definitions

PatX - contains the properties at x, it holds things such as the shortest distance to the body, the velocity of the body at this point, etc.

mu0 - returns the beta at the given location x. The beta is the mu_0 field if the BDIM equation (equation 17 in (1))

distance - is the closest distance to the body, distance2 is the distance to the other bodies, like a distance between bodies, it is used when you do union or differences only.

mu1n - is the normal component of the 1st moment (mu_1 in equation 17), its a second-order tensor so each vector is a component of it.

Lines 130-148 -  generates the kernel to integrate pressure and velocities on the body.







(1) Maertens, Audrey P, Weymouth, Gabriel D, Accurate Cartesian-grid simulations of near-body flows at intermediate Reynolds numbers, Computer Methods in Applied Mechanics and Engineering, 2015.
