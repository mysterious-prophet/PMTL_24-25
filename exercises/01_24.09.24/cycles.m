% function to show simple for and while cycles
% try to use debugging breaking points by clicking line numbers in the left
% to see the values of variables before the function finishes

function count = cycles(n)
    % it is necessary to first declare the count variable
    count = 0;

    %% double for cycle
    for i = 1:2:n
        for j = 1:(n-2)
            count = count + 1;
        end
    end

    %% while cycle
    while(n > 0)
        count = count - 10;
        n = n - 1;
    end
end