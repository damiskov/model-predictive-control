import numpy as np


def p_controller(r, z, u_prev, Kp, umin=np.array([0,0]), umax=np.array([300,300])):
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

    if np.any(u)<0:
        raise ValueError("Control input is negative")
    
    
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

    i_new = i + Ki*dt*(r - z)
    v = u_prev + Kp*(r - z) + i_new
    
    # Saturation based anti wind up

    # if np.any(v > umax) or np.any(v < umin):
    #     i_new = i 

    u = np.maximum(umin, np.minimum(umax, v))

    
    return u, i_new


def pid_controller(i,dt, r, z,z_prev, u_prev, Kp, Ki,Kd, umin=np.array([0,0]), umax=np.array([300,300])):
    e = r - z
    i_new = i + Ki*dt*e
    # v = u_prev + Kp*(e) + Kd*(z-z_prev)/dt + i_new
    v = u_prev + Kp*(r - z) + Ki*dt*i - Kd*(z-z_prev)/dt
    # Saturation based anti wind up

    # if np.any(v > umax) or np.any(v < umin):
    #     i_new = i 

    u = np.maximum(umin, np.minimum(umax, v))
    if np.any(u)<0:
        raise ValueError("Control input is negative")

    return u, i_new