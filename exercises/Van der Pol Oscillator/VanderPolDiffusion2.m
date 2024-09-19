function g = VanderPolDiffusion2(t, x, p)
    %{  
        State dependent diffusion equation
    %}
    sigma = p(2);
    g = [0.0; sigma*(1.0+x(1)*x(1))];