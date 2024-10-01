import numpy as np

class SDE_solver:

    def __init__(self) -> None:
        # No constructor necessary for now
        pass

    def newton_solver(self, ffun, t, dt, psi, x0, tol=1e-8, max_iter=100):
        """
        Implementation of a Newton method in an implicit-explicit SDE solver

        Parameters
        ----------
        ffun : callable
            Function of system. (Also returns Jacobian)
        t : array_like
            Time points
        dt : float 
            Time step
        psi : callable 
            Function that returns the diffusion of the SDE
        x0 : array_like
            Initial condition
        tol : float
            Tolerance for the Newton solver
        max_iter : int  
            Maximum number of iterations

        Returns
        -------
        x : array_like
            Solution of the SDE
        f : array_like
            Final function value
        J : array_like
            Jacobian of the drift
        """

        I = np.eye(len(x0))
        x = x0
        f,J = ffun(t, x)
        R = x - f*dt-psi
        i = 0
        while (np.linalg.norm(R, np.inf) > tol) and (i < max_iter):
            dRdx = I - dt*J
            mdx = np.linalg.solve(dRdx, R)
            x = x-mdx
            f,J = ffun(t, x)
            R = x - f*dt-psi
            i += 1
        return x, f, J

    def explicit_explicit(self, ffun, gfun, T, x0, W):
        """
        Implementation of an explicit explicit (Euler method) SDE solver

        Parameters
        ----------
        ffun : callable
            Function of system. (Also returns Jacobian)
        gfun : callable
            Function that returns the diffusion of the SDE
        T : array_like
            Time points
        x0 : array_like
            Initial condition
        W : array_like
            Random variable (White noise according to the Wiener process)

        Returns
        -------
        X : array_like
            Solution of the SDE
        """

        N = len(T)
        nx = len(x0)
        X = np.zeros((nx, N)) # columns are the time points, rows are the states
        X[:, 0] = x0
        for k in range(N-1):
            f = ffun(T[k], X[:, k])
            g = gfun(T[k], X[:, k])
            dt = T[k+1] - T[k]
            dW = W[:, k+1] - W[:, k]
            psi = X[:, k]+g*dW
            X[:, k+1] = psi+f*dt
        return X
    
    def implicit_explicit(self, ffun, gfun, T, x0, W):
        """
        Implementation of an implicit explicit SDE solver (for 'stiff' systems)
        (https://en.wikipedia.org/wiki/Stiff_equation)

        Parameters
        ----------
        ffun : callable
            Function of system. (Also returns Jacobian)
        gfun : callable
            Function that returns the diffusion of the SDE
        T : array_like
            Time points
        x0 : array_like
            Initial condition
        W : array_like
            Random variable (White noise according to the Wiener process)

        Returns
        -------
        X : array_like
            Solution of the SDE
        """

        N = len(T)
        nx = len(x0)
        X = np.zeros((nx, N))
        X[0, :] = x0
        # f, _ = ffun(T[0], X[:, 0]), pointless evaluation, not sure why John included it
        for k in range(N-1):
            g = gfun(T[k], X[:, k])
            dt = T[k+1] - T[k]
            dW = W[:, k+1] - W[:, k]
            psi = X[:, k]+g*dW
            x, _, _ = self.newton_solver(ffun, T[k], dt, psi, X[:, k])
            X[:, k+1] = x
        return X