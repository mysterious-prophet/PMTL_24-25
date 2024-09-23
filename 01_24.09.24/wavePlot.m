% wave plot
% using a function this time
% note the [] for empty output parameters
% call this function from command window as wave(sigma, omega, r)
function [] = wavePlot(sigma, omega, r)

    % x range
    x = -100:0.1:100;
    % x logical indexing - abs(x) <= r returns logical 0/1 indexing of
    % values of x whose absolute value is smaller than input parameter r
    x = x(abs(x) <= r);

    % wave function 
    % using element-wise .^2 and element-wise matrix multiplication .*
    y = exp(-x.^2/(2*sigma^2)) .* cos(omega*x);
    
    % new figure
    figure;
    plot(x, y);
    title('Plot of wave function y(x)');
    legend('y(x)');
    xlabel('x');
    ylabel('y(x)');
end