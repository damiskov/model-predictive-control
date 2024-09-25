mu = 3;
sigma=1.0;
x0 = [0.5; 0.5];
p = [mu; sigma];

tf = 5*mu;
nw = 1;
N = 1000;
Ns = 5;
seed = 100;

disp('Solving Van der Pol problem:');
fprintf('mu: %d\n', mu);
fprintf('sigma: %d\n', sigma);
fprintf('x0:\n');
disp(x0);
fprintf('Number of simulations: %d\n', Ns);
[W, T, ~] = StdWienerProcess(tf, N, nw, Ns, seed);
X = zeros(length(x0), N+1, Ns);
for i=1:Ns
    fprintf('Simulation i = %i\n', i);
    % Stochastic simulation
    X(:, :, i) = SDEsolverExplicitExplicit(...
                                           @VanderPolDrift, @VanderPolDiffusion1,...
                                            T,x0,W(:,:,i),p);
end

% Deterministic simulation
Xd = SDEsolverExplicitExplicit(...
                                @VanderPolDrift, @VanderPolDiffusion1,...
                                T,x0,W(:,:,i),[mu; 0.0]);

%--------------------------------
% Plotting state independent model
%--------------------------------
figure;
plot(Xd(1,:), Xd(2, :), 'Color', "#000000", 'LineWidth', 2);
colors = ["#D95319","#EDB120","#7E2F8E","#77AC30","#4DBEEE"];
hold on
for i =1:Ns
    plot(X(1,:, i), X(2, :, i), 'Color', colors(i), 'LineWidth', 1);
end

xlabel('x_1')
ylabel('x_2')
savefig('vanderpol_state_independent.fig')
