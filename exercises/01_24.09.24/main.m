% Main program calling firstFunction.m
% wait on user input of a, b
% if we input a character (except i, j for imaginary unit) or string we get
% an error as Matlab tries to look for a variable or function of this name
a = input('a: ');
b = input('b: ');

% call the function firstFunction with numeric params. a, b and assign its 
% output to c
c = firstFunction(a,b);