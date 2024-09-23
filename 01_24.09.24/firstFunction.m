% first function
% declaration of function firstFunction using the function keyword
% one output parameter pyth (try renaming all occurences using shift+enter)
% two input parameters - x, y - note the absence of datatype
function pyth = firstFunction(x, y)
    % redundant declaration using min and max to show off these commands
    temp1 = min(x, y);
    temp2 = max(x, y);

    % output parameter pyth
    pyth = temp1^2 + temp2^2;  
end