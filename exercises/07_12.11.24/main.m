clear; clc; close all;

%% 1. Genetic optimization algorithm using OOP
ga = GeneticAlgorithm(250, 100, 0.01, 50);
ga.run();
delete(ga);

% static method example
random_chromosome = GeneticAlgorithm.generateRandomChromosome(10);
disp('Random Chromosome Example:');
disp(random_chromosome);

%% 2. Simulated Annealing
% Define the objective function (e.g., Rosenbrock function)
objective_func = @(x) (1 - x(1))^2 + 100 * (x(2) - x(1)^2)^2;

% Plot the Rosenbrock function
[x1, x2] = meshgrid(-2:0.1:2, -1:0.1:3);
z = (1 - x1).^2 + 100 * (x2 - x1.^2).^2;
figure;
surf(x1, x2, z);
title('Rosenbrock Function');
xlabel('x1');
ylabel('x2');
zlabel('Objective Value');

% Initialize the Simulated Annealing class
sa = SimulatedAnnealing(objective_func, 100, 0.9, 1000);

% Run optimization starting from an initial guess
init_guess = [1, 0];
sa = sa.optimize(init_guess);

% Display results
disp('Best Solution Found:')
disp(sa.best_sol)
disp('Objective Value at Best Solution:')
disp(sa.best_val)

%% 3. Edge Detection
% Initialize the CustomEdgeDetection class with an image file path
% we can use, for example, Lenna - a famous, standard test image, available for download:
% https://en.wikipedia.org/wiki/Lenna
edge_detector = EdgeDetection('lenna.png');

% Apply Sobel edge detection and display the result
edge_detector = edge_detector.sobelEdgeDetection();
edge_detector.showResult('Sobel Edge Detection');