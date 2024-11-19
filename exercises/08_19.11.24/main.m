clear; clc; close all;

%% 1. Edge Detection
% Initialize the CustomEdgeDetection class with an image file path
% img source: https://www.thesprucecrafts.com/top-coin-picks-3898463
edge_detector = EdgeDetection('coins.jpg');

% Apply Sobel edge detection and display the result
edge_detector = edge_detector.sobelEdgeDetection();
edge_detector.showResult('Sobel Edge Detection');

% Apply Prewitt edge detection and display the result
edge_detector = edge_detector.prewittEdgeDetection();
edge_detector.showResult('Prewitt Edge Detection');

% Apply Laplacian edge detection and display the result
edge_detector = edge_detector.laplacianEdgeDetection();
edge_detector.showResult('Laplacian Edge Detection');

%% 2. Swarm Simulation
% Swarm simulation parameters
num_particles = 50;
num_steps = 100;

% Initialize swarm
swarm = SwarmSimulation(num_particles);

% Set up the figure
figure;
axis([0 10 0 10]);
title('Swarm Simulation');
xlabel('X Position');
ylabel('Y Position');

% Run the simulation
for step = 1:num_steps
    % Update velocities and positions
    swarm = swarm.updateVelocities();
    swarm = swarm.updatePositions();

    % Clear and replot the positions
    clf;
    plot(swarm.positions(:, 1), swarm.positions(:, 2), 'bo');
    axis([0 10 0 10]);
    title('Swarm Simulation');
    xlabel('X Position');
    ylabel('Y Position');

    % Pause to visualize the animation
    pause(0.05);
end

%% 3. Markov Chain for Text Generation
% Initialize the Markov Chain with an order - next state
% depends on current state and n-1 previous states
generator = MarkovChainTextGenerator(1);

% Train the Markov Chain with a sample text
% sample_text = "To be or not to be that is the question whether tis nobler in the mind to suffer the slings and arrows of outrageous fortune";
sample_text = "Stately, plump Buck Mulligan came from the stairhead, bearing a bowl of lather on which a mirror and a razor lay crossed A yellow dressinggown, ungirdled, was sustained gently behind him on the mild morning air";
generator = generator.train(sample_text);

% Generate new text with 20 words
generated_text = generator.generateText(20);
disp("Generated Text:");
disp(generated_text);

%% 4. Object-Oriented Animation of Physical Simulations
% Define pendulum parameters
length = 1;
mass = 1;
init_angle = pi / 2;
init_angular_vel = 0;
gravity = 9.81;
time_step = 0.05;
damping = 0.1;

% Instantiate the PendulumSimulation with the parameters
pendulum = PendulumSimulation(length, mass, init_angle, init_angular_vel, gravity, time_step, damping);

% Run the simulation for 20 seconds
pendulum.simulate(20);
