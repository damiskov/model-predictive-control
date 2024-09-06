function xdot = QuadrupleTankProcess(t, x_k, u_k, p)

    % p = [a1; a2; a3; a4; A1; A2; A3; A4; g; gamma1; gamma2];
    a1 = p(1);
    a2 = p(2);
    a3 = p(3);
    a4 = p(4);
    A1 = p(5);
    A2 = p(6);
    A3 = p(7);
    A4 = p(8);
    g = p(9);
    gamma1 = p(10);
    gamma2 = p(11);

    F1 = u_k(1);
    F2 = u_k(2);

    xdot = zeros(4, 1);

    xdot(1) = (gamma1/A1)*F1 + (a3/A1)*sqrt(2*g*x_k(3)) - (a1/A1)*sqrt(2*g*x_k(1));
    xdot(2) = (gamma2/A2)*F2 + (a4/A2)*sqrt(2*g*x_k(4)) - (a2/A2)*sqrt(2*g*x_k(2));
    xdot(3) = F2*(1-gamma2)/A3 - (a3/A3)*sqrt(2*g*x_k(3));
    xdot(4) = F1*(1-gamma1)/A4 - (a4/A4)*sqrt(2*g*x_k(4));


end