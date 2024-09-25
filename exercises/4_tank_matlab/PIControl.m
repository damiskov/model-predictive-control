%{
    Simple implementation of a Proportional controller
    Inputs:
        - i: rolling sum for integral 
        - r: Target config.
        - z: Current config.
        - 
        - kC: Control constant
%}


function [u, i] = PIControl(i,r,z,us,kC,dt,umin,umax)
    err = r-z;
    v = us + kC*err+i;
    i = i + kC*dt*err;
    u= max(umin,min(umax,v));
end