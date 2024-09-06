% ------------------------
% Parameter values
% ------------------------

a1 = 1.2272;     %[cm2] Area of outlet pipe 1
a2 = 1.2272;    %[cm2] Area of outlet pipe 2
a3 = 1.2272;     %[cm2] Area of outlet pipe 3
a4 = 1.2272;     %[cm2] Area of outlet pipe 4
A1 = 380.1327;   %[cm2] Cross sectional area of tank 1
A2 = 380.1327;   %[cm2] Cross sectional area of tank 2
A3 = 380.1327;   %[cm2] Cross sectional area of tank 3
A4 = 380.1327;   %[cm2] Cross sectional area of tank 4
g = 981;         %[cm/s2] The acceleration of gravity
gamma1 = 0.45;  % Flow distribution constant. Valve 1
gamma2 = 0.40;  % Flow distribution constant. Valve 2
p = [a1; a2; a3; a4; A1; A2; A3; A4; g; gamma1; gamma2];



% ------------------------------------------------------------
% Specify Controller
% ------------------------------------------------------------
controller = ''; % Simulate without any controller

% ------------------------------------------------------------
% Initial Conditions
% ------------------------------------------------------------
t0 =    0.0;        % [s] Initial time
tf = 20*60;         % [s] Final time
h10 = 0.0;          % [cm] Liquid level in tank 1 at time t0
h20 = 0.0;          % [cm] Liquid level in tank 2 at time t0
h30 = 0.0;          % [cm] Liquid level in tank 3 at time t0
h40 = 0.0;          % [cm] Liquid level in tank 4 at time t0
F1 = 300;           % [cm3/s] Flow rate from pump 1
F2 = 300;           % [cm3/s] Flow rate from pump 2


% Ignoring "Measurement" and "Output" variables 
% y = zeros(1,tf);
% z = zeros(1,tf);
t = t0:tf;
x = zeros(4,tf);
x(:, 1) = [h10; h20; h30; h40];
u = zeros(2, tf);
u(:, 1) = [F1; F2];

if strcmp(controller, 'PI')
    % Implement PI controller
elseif strcmp(controller, 'P')
    % Implement P controller
else 
    % No controller, assume constant flow-rate for entire time-frame
    for k =1:tf
        u(:, k) = [F1; F2];
    end
end

% Simulating

% Sum dummy options
ODEoptions = odeset();

for k = 2:tf-1
    [~, X] = ode15s(@QuadrupleTankProcess,...
     [t(k) t(k+1)], x(:,k), ODEoptions, u(:, k), p);
     x(:, k+1) = X(end, :)';
end 


% Plotting heights

% Create a figure
figure;

% First subplot - Tank 1
subplot(4,1,1);
plot(t(1:end-1), x(1, 1:end), 'r');
title('Tank 1');

% Second subplot - Tank 2
subplot(4,1,2);
plot(t(1:end-1), x(2, 1:end), 'r');
title('Tank 2');

% Third subplot - Tank 3
subplot(4,1,3);
plot(t(1:end-1), x(3, 1:end), 'r');
title('Tank 3');

% Fourth subplot - Tank 4
subplot(4,1,4);
plot(t(1:end-1), x(4, 1:end), 'r');
title('Tank 4');
