import numpy as np

def vdp_drift(t, x, p):
    """"
    Drift term for the Van der Pol oscillator.

    Parameters
    ----------
    t : float
        Time
    x : array_like
        State of the system 
    p : array_like
        Parameters of the system
    
    Returns
    -------
    f : array_like
        Drift term (vector)
    J : array_like
        Jacobian of the drift
    """

    mu = p[0]
    tmp = mu*(1-x[0]**2)
    f = np.array([x[1], mu*(1-x[0]**2)*x[1]-x[0]])
    J = np.array([[0, 1], [-2*tmp*x[1], tmp]])
    return f, J



def diff_state_independent(t, x, p):
    """"
    State independent diffusion term for the Van der Pol oscillator.

    Parameters
    ----------
    t : float
        Time
    x : array_like
        State of the system 
    p : array_like
        Parameters of the system
    
    Returns
    -------
    g : array_like
        Diffusion term (matrix)
    """

    sigma = p[1]
    g = np.array([[0], [sigma]])
    return g

def diff_state_dependent(t, x, p):
    """"
    State dependent diffusion term for the Van der Pol oscillator.

    Parameters
    ----------
    t : float
        Time
    x : array_like
        State of the system 
    p : array_like
        Parameters of the system
    
    Returns
    -------
    g : array_like
        Diffusion term (matrix)
    """

    sigma = p[1]
    g = np.array([[0, 0], [0, sigma*(1+(x[0]**2))]])
    return g