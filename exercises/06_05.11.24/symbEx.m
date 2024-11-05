function [lim_x, der_f] = symbEx()
    syms x n;
    lim_x = limit((1 - cos(x))/x^2, x, 0);
    
    exp_x = limit((1 + x/n)^n, n, inf);
    
    f = exp_x / cos(x);
    der_f = diff(f);
end