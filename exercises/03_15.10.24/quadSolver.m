function result = quadSolver(a, b, c)
    disc = b^2 - 4*a*c;
    % discriminant conditions
    if(disc > 0)
        x1 = (-b+sqrt(disc))/(2*a);
        x2 = (-b-sqrt(disc))/(2*a);
        % cell array
        result = {x1, x2};
    elseif(disc == 0)
        result = -b/(2*a);
    else
        disp('Error: No real solution!');
        result = {};
    end
end