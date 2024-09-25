function z = QuadrupleTankOutput(x, p)
    %{
        Output function for the simple 4-tank system.

        The level of tanks 1 and 2.
    %}
    
    A = p(5:6, 1);
    rho = p(12,1);
    m=x(1:2);

    z= m./(rho*A);
end