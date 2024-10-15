function result = fibonacciIter(n)

    % iterative approach
    % fibonacci sequence initial conditions
    if n <= 0
        result = [];
    elseif n == 1
        result = 0;
    elseif n == 2
        % you could also write [0, 1] - there is no difference
        result = [0 1];
    else
        result = zeros(1, n);
        result(1) = 0;
        if n > 1
            result(2) = 1;
        end
        
        for i = 3:n
            result(i) = result(i-1) + result(i-2);
        end
    end
end