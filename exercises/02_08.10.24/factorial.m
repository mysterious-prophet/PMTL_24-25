function fac = factorial(n)
    % double condition for inputs using and - &&
    if(n >= 0 && round(n) == n)
        fac = 1;
        for i = n:-1:2
            fac = fac * i;
        end
    % error
    else
        disp('Error: Invalid input!');
        fac = {};
    end
end