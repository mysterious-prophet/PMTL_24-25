% basics of symbolic programming
% used to solve problems symbolically (like e.g. Wolfram Alpha) not
% numerically

% note that if we call the function from the command window only as symbols
% without assigning its output parameter values to some variables, we only
% receive the first parameter der_cos as the ans
function [der_cos, expo] = symbolicProgramming()

    % declare a list of symbolic variables using the syms keywords
    syms h x n;

    %% derivative of cosine
    % limit(expression, variable, target)
    der_cos = limit((cos(x+h) - cos(x))/h, h, 0);

    %% exponential e^x as a limit
    % note the use of inf keyword
    expo = limit((1 + x/n)^n, n, inf);
end