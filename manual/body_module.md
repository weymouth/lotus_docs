
# body.f90 notes and definitions

**PatX** - contains the properties at x, it holds things such as the shortest distance to the body, the velocity of the body at this point, etc.

**mu0** - returns the beta at the given location x. The beta is the mu_0 field if the BDIM equation (equation 17 in (1))

**distance** - is the closest distance to the body, distance2 is the distance to the other bodies, like a distance between bodies, it is used when you do union or differences only.

**mu1n** - is the normal component of the 1st moment (mu_1 in equation 17), its a second-order tensor so each vector is a component of it.

Lines 130-148 -  generates the kernel to integrate pressure and velocities on the body.

**vforce** - This is the process that computes the frictional velocity on the body. It computes the derrivative of x then multiplies by something to do with the kernel (maybe direction to).

**dxi,dxj,dxk** - The rectalinear grid spacing in x,y,z for scaling quantities by cell width.

**e(1,2,3)** - Defines the scalar quantity from the unit vector in x,y,z.

**%point** - points to the location of a field or array, if an argument is given then it can shift that array in x or y for use in defining the derivatives via the central difference scheme.


(1) Maertens, Audrey P, Weymouth, Gabriel D, Accurate Cartesian-grid simulations of near-body flows at intermediate Reynolds numbers, Computer Methods in Applied Mechanics and Engineering, 2015.
