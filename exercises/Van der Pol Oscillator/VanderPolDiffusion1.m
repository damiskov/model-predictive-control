function g = VanderPolDiffusion1(t, x, p)
    %{
        State independent diffusion equation
    %}
    sigma = p(2);
    g = [0.0; sigma];
    
