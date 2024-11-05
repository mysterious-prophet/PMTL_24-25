% Function to estimate Pi using a Monte Carlo simulation
function [pi_est, x, y, circle_inside] = monteCarloPi(num_points)
    % num_points: Number of random points used in the simulation
    
    x = rand(1, num_points);
    y = rand(1, num_points);

    % Calculate distances from the origin
    dists = sqrt(x.^2 + y.^2);

    % Points inside the unit circle
    circle_inside = dists <= 1;

    % Estimate of Pi is 4 times the area of quarter circle
    pi_est = 4 * sum(circle_inside) / num_points;
end