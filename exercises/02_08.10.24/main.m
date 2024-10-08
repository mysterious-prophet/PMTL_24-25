clear; clc; close all;

%% factorial
inp = input('factorial input: ');
fac = factorial(inp);
if(size(fac, 1) > 0)
    % fprinf prints a formatted output to the console
    % %d is an integer
    format_spec = 'The factorial of %d is %d \n';
    fprintf(format_spec, inp, fac);
end