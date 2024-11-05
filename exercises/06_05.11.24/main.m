clear; clc; close all;

%% 1. d) bubble sort
rand_vect = randi(1000, 1, 100);
disp('Unsorted vector: ');
disp(rand_vect);
rand_vect_sort = bubbleSort(rand_vect);
disp('Sorted vector: ');
disp(rand_vect_sort);

% matlab in-built sort (probably close to vanilla quicksort)
rand_vect_sort2 = sort(rand_vect);
disp('Vector x sorted with MATLAB built-in function: ');
disp(rand_vect_sort2);

%% 2. plotting
x = 0:pi/20:2*pi;
y1 = sin(x);
y2 = cos(x);
y3 = ones(1, size(x, 2));

% try inspecting the fig object
fig = figure;
hold on
plot(x, y1, 'LineWidth', 3);
plot(x, y2, 'g--');
plot(x, y3, 'rx');
hold off
axis([0 2*pi -1.5 1.5]);
title('Exercise plot');
leg = legend('sin(x)', 'cos(x)', 'I(x)', 'Location', 'best');
title(leg, 'Legend');
xlabel('x');
ylabel('f(x)');

%% 3. a), b) limit and derivative
[lim_x, der_f] = symbEx();

%% 3. c) anonymous function, diff, matlabFunction 

% Define an anonymous function f(x) = sin(x) + cos(x^2)
f = @(x) sin(x) + cos(x.^2);

% Define linspace range of 1000 values from 0 to 10
x = linspace(0, 10, 1000);

% Plot f(x)
figure;
plot(x, f(x), 'b-', 'LineWidth', 2);
hold on;

% Define the derivative of f(x) using diff and matlabFunction
syms x_sym;
f_sym = sin(x_sym) + cos(x_sym^2);
f_der_sym = diff(f_sym, x_sym);
% this converts the symbolic expression to a matlab function
f_der = matlabFunction(f_der_sym);

% Plot the derivative g(x)
plot(x, f_der(x), 'r-', 'LineWidth', 2);

% Add title and labels
title('Plot of f(x) and its derivative g(x)');
xlabel('x');
ylabel('y');
legend('f(x) = sin(x) + cos(x^2)', "g(x) = f(x)'", 'Location', 'best');
hold off;

%% 4. random walk with plot
randomWalk(1000, 3);

%% 5. Monte Carlo Pi estimation
[pi_est, x, y, circle_inside] = monteCarloPi(10000);

% Display the estimated value of Pi
fprintf('Estimated value of Pi: %f \n', pi_est);

% Plot the points
figure;
hold on;
plot(x(circle_inside), y(circle_inside), 'b.');
plot(x(~circle_inside), y(~circle_inside), 'r.');
title('Monte Carlo Simulation for Estimating Pi');
xlabel('x');
ylabel('y');
legend('Inside Circle', 'Outside Circle');
axis square;
hold off;

%% 6. Genetic optimization algorithm using OOP
ga = GeneticAlgorithm(250, 100, 0.01, 50);