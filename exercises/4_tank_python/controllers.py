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


def pi_controller(i,dt, r, z, u_prev, Kp, Ki, umin=np.array([0,0]), umax=np.array([300,300])):
    """
    Proportional-Integral controller.
    
    Parameters:
        r (float): Reference value.
        z (float): Current value.
        u_prev (float): Previous control input.
        Kp (float): Proportional gain.
        Ki (float): Integral gain.
    
    Returns:
        u (float): Control input.
    """
    v, u = np.zeros_like(u_prev), np.zeros_like(u_prev)

    i = i + Ki*dt*(r - z)
    v = u_prev + Kp*(r - z) + i

    u = np.maximum(umin, np.minimum(umax, v))

    # Anti-windup: prevent integral term from growing if output is saturated
    # if np.any(u == umin) or np.any(u == umax):
    #     i = 0  # Reset integral if saturation happens

    
    return u, i