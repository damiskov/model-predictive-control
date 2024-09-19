%{
    Discrete-time implementation of 4-tank system
%}
% ------------------------------------------------------------
% Specify Controller
% ------------------------------------------------------------
controller = 'PI'; % Controller: 'none', 'P', 'PI'
% ------------------------------------------------------------
% Parameter values
% ------------------------------------------------------------
a1 = 1.2272;     %[cm2] Area of outlet pipe 1
a2 = 1.2272;    %[cm2] Area of outlet pipe 2
a3 = 1.2272;     %[cm2] Area of outlet pipe 3
a4 = 1.2272;     %[cm2] Area of outlet pipe 4
A1 = 380.1327;   %[cm2] Cross sectional area of tank 1
A2 = 380.1327;   %[cm2] Cross sectional area of tank 2
A3 = 380.1327;   %[cm2] Cross sectional area of tank 3
A4 = 380.1327;   %[cm2] Cross sectional area of tank 4
A = [A1 A2 A3 A4];
g = 981;         %[cm/s2] The acceleration of gravity
gamma1 = 0.45;  % Flow distribution constant. Valve 1
gamma2 = 0.40;  % Flow distribution constant. Valve 2
rho=1.00; % [g/cm3] Density of water 
p = [a1; a2; a3; a4; A1; A2; A3; A4; g; gamma1; gamma2;rho];
% ------------------------------------------------------------
% Initial Conditions
% ------------------------------------------------------------
m10 = 0.0;          % [g] Liquid mass in tank 1 at time t0
m20 = 0.0;          % [g] Liquid mass in tank 2 at time t0
m30 = 0.0;          % [g] Liquid mass in tank 3 at time t0
m40 = 0.0;          % [g] Liquid mass in tank 4 at time t0
x0 = [m10 m20 m30 m40]; % Initial conditions
F1 = 300;           % [cm3/s] Flow rate from pump 1
F2 = 300;           % [cm3/s] Flow rate from pump 2
% ------------------------------------------------------------
% Time
% ------------------------------------------------------------
N = 50; % Number of minutes to simulate
t0 = 0.0;        % [s] Initial time
tf = (N-1)*60;         % [s] Final time
t=t0:60:tf;
% ------------------------------------------------------------
% Initialising Variables
% ------------------------------------------------------------
x = zeros(4,N);
x(:, 1) = [m10; m20; m30; m40];
% Sensor - Heights of all tanks
y = zeros(4,N);
y(:, 1) = QuadrupleTankSensor(x(:, 1), p);
% Output - Heights of tank 1 and 2
z = zeros(2,N);
z(:, 1) = QuadrupleTankOutput(x(:, 1), p);
u = zeros(2, N);
u(:, 1) = [F1; F2];


% ------------------------------------------------------------
% Target - heights of tanks 1, 2 [cm]
% ------------------------------------------------------------
r = [8; 6];
m_ref = r.*A(1:2)'*rho;


% ------------------------------------------------------------
% Simulate process  
% ------------------------------------------------------------

% RUNNING A CONTINUOUS-TIME SIMULATION TO GET nX - NOT SURE HOW ELSE TO DO THIS  
[Tcont, Xcont] = ode15s(@QuadrupleTankProcess,...
    [t0 tf], x0,[], u, p);
[nT, nX] = size(Xcont);


X = zeros(0, nX);
T = zeros(0, 1);

% Set up for controller
i =0;
kC=5;
dt = 60; % Updating every minute
umin = [0; 0];
umax = [1e3; 1e3];

for k =2:N-1
    % ------------------------------------------------------------
    % Output based on controller
    % ------------------------------------------------------------
    if strcmp(controller, 'none')
        u(:, k) = [F1;F2];
    elseif strcmp(controller, 'P')
        u(:, k) = PControl(r, z(:, k-1), u(:, k-1), kC, umin, umax);
    elseif strcmp(controller, 'PI')
        [u(:, k), i] = PIControl(i,r,z(:, k-1),u(:, k-1),kC,dt,umin,umax);
    else
        error('Incorrect controller selected');
    end
        
    %-------------------------
    % Simulate step  
    %-------------------------

    y(:, k) = QuadrupleTankSensor(x(:, k), p);
    z(:, k) = QuadrupleTankOutput(x(:, k), p);

    [Tk, Xk] = ode15s(@QuadrupleTankProcess,...
    [t(k) t(k+1)], x(:,k),[], u(:, k), p);

    x(:, k+1) = Xk(end, :)';


    T = [T; Tk];
    X = [X; Xk];
    
    
end
k = N;
y(:, k) = QuadrupleTankSensor(x(:, k), p);
z(:, k) = QuadrupleTankOutput(x(:, k), p);


disp('---Target Mass:----')
fprintf('Tank 1: %d [g]\n', m_ref(1));
fprintf('Tank 2: %d [g]\n', m_ref(2));
disp('------------------')
figure;
for i =1:4
    subplot(2,2,i)
    plot(T,X(:, i));
    title(sprintf('Tank %i', i))
    xlabel('t [s]]')
    ylabel(sprintf('m_%i [g]', i))
end

figure;
for i = 1:2
    subplot(2, 1, i)
    plot(0:N-1, u(i, :))
    title(sprintf('Flow Rate %i', i))
    xlabel('t [min]')
    ylabel(sprintf('F_%i [cm3/s]', i))
end