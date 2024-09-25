import numpy as np


def p_controller(r, z, u_prev, Kp, umin=np.array([0,0]), umax=np.array([400,400])):
    """
    Proportional controller.
    
    Parameters:
        r (float): Reference value.
        z (float): Current value.
        u_prev (float): Previous control input.
        Kp (float): Proportional gain.
    
    Returns:
        u (float): Control input.
    """
    v, u = np.zeros_like(u_prev), np.zeros_like(u_prev)

    v = u_prev + Kp*(r - z)
   
    
    u = np.maximum(umin, np.minimum(umax, v))
    
    
    return u