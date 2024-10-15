%% wrapper function
function result = fibonacciRecur(n)
    if n <= 0
        result = [];
    elseif n == 1
        result = 0;
    else
        result = zeros(1, n);
        result(1) = 0;

        if n > 1
            result(2) = 1;
        end

        if(n > 2)
            result = calcFibSequence(result, 3, n);
        end
    end
end

%% helper function generates the sequence recursively
function result = calcFibSequence(result, cur_ind, n)
    if cur_ind <= n
        result(cur_ind) = result(cur_ind - 1) + result(cur_ind - 2);
        result = calcFibSequence(result, cur_ind + 1, n);
    end
end