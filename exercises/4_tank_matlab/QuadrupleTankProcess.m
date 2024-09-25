function xdot = QuadrupleTankProcess(t, x, u, p)
    %{
        Process Model for the simple 4-tank system.

        Implements a differential equation model for the 4-tank system.

        Inputs:
            - x_k: Current mass values for each tank.
            - u_k: Current controller value (I.e., flow rates)
            - p: Parameters
        Outputs:
            - xdot: Derivative of mass w.r.t time
    %}

     
    % Unpacking states, parameters
    a = p(1:4); % Pipe cross sectional areas [cm2]
    A = p(5:8); % Tank cross sectional areas [cm2]
    g = p(9); % Acceleration of gravity [cm/s2]
    gamma = p(10:11); % Valve positions [-]
    rho = p(12); % Density of water [g/cm3]
    F = u; % Flow rates in pumps [cm3/s]
    m = x; % Mass of liquid in each tank [g]
    
    % Heights
    h = m./(rho*A); % Liquid level in each tank [cm]
    % Outflows
    qout = a.*sqrt(2*g*h); % Outflow from each tank [cm3/s]
    
    % Inflow
    qin = zeros(4, 1);
    qin(1,1) = gamma(1)*F(1); % Inflow from valve 1 to tank 1 [cm3/s]
    qin(2,1) = gamma(2)*F(2); % Inflow from valve 2 to tank 2 [cm3/s]
    qin(3,1) = (1-gamma(2))*F(2); % Inflow from valve 2 to tank 3 [cm3/s]
    qin(4,1) = (1-gamma(1))*F(1); % Inflow from valve 1 to tank 4 [cm3/s]
    
    % Differential equations
    xdot = zeros(4,1);
    xdot(1,1) = rho*(qin(1,1)+qout(3,1)-qout(1,1)); % Mass balance Tank 1
    xdot(2,1) = rho*(qin(2,1)+qout(4,1)-qout(2,1)); % Mass balance Tank 2
    xdot(3,1) = rho*(qin(3,1)-qout(3,1)); % Mass balance Tank 3
    xdot(4,1) = rho*(qin(4,1)-qout(4,1)); % Mass balance Tank 4
end