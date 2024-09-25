function y = QuadrupleTankSensor(x, p)
    %{
        Sensor function for the simple 4-tank system.

        The level of each tank.
    %}
    A = p(5:8, 1);
    rho = p(12,1);
    m=x;

    y = m./(rho*A);
end