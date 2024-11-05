function x = bubbleSort(x)
    % we are using n several times in for cycles, it is useful to have it
    % as a variable
    n = size(x, 2);

    % if n == 1 then then x is already sorted and we can go back using
    % return
    if(n == 1)
        return
    else
        for i = 1:n
            % flag whether we did any sorting in this cycle
            flag = 0;
            for j = 1:n-i
                % ascending condition, for descend use <
                if(x(j) > x(j+1))
                    % bubbling up
                    temp = x(j);
                    x(j) = x(j+1);
                    x(j+1) = temp;
                    flag = 1;
                end
            end
            if(flag == 0)
                break
            end
        end
    end
end