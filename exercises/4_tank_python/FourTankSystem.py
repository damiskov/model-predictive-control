"""
Class for the 4-tank system

Author: David Miles-Skov
Date: 25/09/2024
"""
import numpy as np


class QuadTankSystem:
    """
    
    Class for the 4-tank system.

    The system consists of 4 tanks, each with a hole in the bottom. The tanks are connected according
    to the schematic which can be found in this directory. The system is controlled by adjusting the flow rate of the pump.

    Note - The class will keep track of PRESENT system state, but will not store the historical states.


    """

    def __init__(self, p) -> None:
        """
        Constructor for the QuadTankSystem class.

        Parameters:
            p (dict): Dictionary containing the parameters of the system.
                - a (np.ndarray): Area of the holes in the tanks. [cm2]
                - A (np.ndarray): Surface area of the tanks. [cm2]
                - g (float): Acceleration due to gravity. [cm/s2]
                - gamma (np.ndarray): Flow distribution constants.
                - rho (float): Density of the water. [g/cm3]
        """
        self.a = p['a']
        self.A = p['A']
        self.g = p['g']
        self.gamma = p['gamma']
        self.rho = p['rho']
        self.m = np.array([0, 0, 0, 0]) # Mass of tanks
        self.h = np.array([0, 0, 0, 0]) # Height of water in tanks

    def print_variables(self) -> None:
        """
        Prints the variables of the system. (mass and height)
        """
        print("Mass: ", self.m)
        print("Height: ", self.h)

        
        

    def set_initial_condition(self, x0):
        """
        Set the initial condition (mass) of the system.
        - Also sets the initial height of the water in the tanks.
        """
        self.m = x0
        self.h = self.m / (self.rho * self.A)

    def update_system(self, u: np.ndarray) -> np.ndarray:
        """
        Updates the system state.
        """
        pass

    def get_state(self) -> np.ndarray:
        """
        Returns the state (mass) of the system.
        """
        return self.m
    
    
    def system_sensor(self, x) -> np.ndarray:
        """
        Returns the sensor measurement for the current state.

        I.e., the height of the water in all 4 tanks.
        """
        
        return x/(self.rho*self.A)
    
    def system_output(self, x) -> np.ndarray:
        """
        Returns the output of the system.

        I.e., the height of water in tanks 1 and 2.
        """
        H = x/(self.rho*self.A)
        return H[0:2]
    
    def process(self, t, x, u):
        """
        The process model for the 4-tank system.

        Parameters:
            t (float): Time.
            x (np.ndarray): State of the system.
            u (np.ndarray): Control input.
        
        Returns:
            dxdt (np.ndarray): Derivative of the state (mass) w.r.t time.
        """

        self.m=x 
        self.h = self.m / (self.rho * self.A) # Update heights
        F = u
        # Check if any of the heirghts are negative/NaNs
        if np.any(np.isnan(self.h)) or np.any(self.h<0):
            raise ValueError(f"Heights are negative or NaNs:\n Heights: {self.h}")

        qout = np.sqrt(2 * self.g * self.h) * self.a # Outflow of each tank (cm3/s)

        # Calculating in flows [cm3/s]

        qin = np.zeros(4)
        qin[0] = F[0]*self.gamma[0] # valve 1 -> tank 1
        qin[1] = F[1]*self.gamma[1] # valve 2 -> tank 2
        qin[2] = F[1]*(1-self.gamma[1]) # valve 2 -> tank 3
        qin[3] = F[0]*(1-self.gamma[0]) # valve 1 -> tank 4

        # ODE - Mass balance
        dxdt = np.zeros(4)
        dxdt[0] = self.rho*(qin[0]+qout[2]-qout[0])
        dxdt[1] = self.rho*(qin[1]+qout[3]-qout[1])
        dxdt[2] = self.rho*(qin[2]-qout[2])
        dxdt[3] = self.rho*(qin[3]-qout[3])

        return dxdt

        
    
        

        
        
        

        

