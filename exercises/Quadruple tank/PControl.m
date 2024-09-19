%{
    Simple implementation of a Proportional controller
    Inputs:
        - r: Target config.
        - z: Current config.
        - u_prev: Controller output in previous time step
        - kP: Proportional constant
%}


function u = PControl(r, z, u_prev, kP, umin, umax)
    [nr, ~] = size(r);
    err = r-z;
    v = u_prev + kP*err;
    u = max(umin,min(umax,v));
end