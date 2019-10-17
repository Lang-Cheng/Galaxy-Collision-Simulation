# Galaxy-Collision-Simulation
N-body problem where each body contains thousands of stars, and simulate collision between galaxies

function [t, r, v, s_r, s_v, s_a] = particleSystem(tmax, level, coreNum, starNum, r0, v0, m, rmin, rmax, clockwise)

    Input arguments

        tmax: (real scalar) Final solution time.

        level: (integer scalar) Discretization level.

        coreNum: (integer scalar) Number of cores, use as N.

        starNum: (integer scalar) Number of stars, use as n.

        r0: (N x 3 array) Initial positions.

        v0: (N x 3 array) Initial velocity.

        m: (Vector of length N) particle masses

        rmin: (integar scalar) the minimum radius of the star distribution

        rmax: (integar scalar) the minimum radius of the star distribution

        clockwise: (boolean) true then stars move in clockwise

    Output arguments

        t: (real vector) Vector of length nt = 2^level + 1 containing discrete times (time mesh).

        r: (N x 3 array) Vector of length nt containing computed 3D position of cores at discrete times t(n).

        v: (N x 3 array) Vector of length nt containing computed 3D velocity of cores at discrete times t(n).

        s_r: (N*n x 3 array) Vector of length nt containing computed 3D position of stars at discrete times t(n).

        s_v: (N*n x 3 array) Vector of length nt containing computed 3D velocity of stars at discrete times t(n).

        s_a: (N*n x 3 array) Vector of length nt containing computed 3D acceleration of stars at discrete times t(n).
        

The function above computes the simulation of galaxy collision under certain initial conditions.

Setup Matlab
---

`run compute.m`
