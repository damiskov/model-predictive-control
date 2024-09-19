function [x, f, J] = SDENewtonSolver(ffun, t, dt, psi, xinit, tol, maxit, varargin)
    %{
        Newton Method in an Implicit-Explicit SDE solver for a stiff system.
        Inputs:
            - ffun, function f of the system (Should also return Jacobian)
            - t, current time
            - dt, time step
            - psi, 
            - xinit, initial x value
            - tol, maxium inf norm value of residual
            - maxit, maximum number of iterations for newton process
            - varargin, other arguments for ffun
        Returns:
            - x, final value for x_k+1
            - f, final function value 
            - J, final jacobian

        Returns:
    %}

    I = eye(length(xinit));
    x = xinit;
    [f, J] = feval(ffun, t, x, varargin{:});
    R = x- f*dt-psi;
    it = 1;
    while ((norm(R, 'inf')>tol) && (it <= maxit))
        dRdx = I-J*dt;
        mdx = dRdx\R;
        x = x-mdx;
        [f,J]= feval(ffun, t, x, varargin{:});
        R = x- f*dt-psi;
        it = it+1;
    end
