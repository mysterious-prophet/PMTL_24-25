%% Infection spread simulation
num_steps = 100;

% Number of individuals and grid size
% If this section runs too slow, try lowering the number of individuals and
% making grid smaller
num_inds = 1000;
grid_size = 100;

% Infection probability rate and infection radius
inf_rate = 0.8;
inf_radius = 3;

% Time steps until recovery or death
recov_time = 14;

% Probability of death
death_prob = 0.3;

% Status history structure and population initialization
status_history = struct('healthy', [], 'infected', [], 'recovered', [], 'dead', []);
pop = Population(num_inds, grid_size, inf_rate, recov_time, death_prob);

for i = 1:num_steps
    pop.moveIndividuals();
    pop.spreadInfection(inf_radius);
    pop.updateStatuses();
    counts = pop.countStatuses();
    status_history.healthy = [status_history.healthy, counts.healthy];
    status_history.infected = [status_history.infected, counts.infected];
    status_history.recovered = [status_history.recovered, counts.recovered];
    status_history.dead = [status_history.dead, counts.dead];

    clf;
    subplot(1, 2, 1);
    pop.displayPopulation();

    subplot(1, 2, 2);
    plot(1:i, status_history.healthy, 'g', 'LineWidth', 2);
    hold on
    plot(1:i, status_history.infected, 'r', 'LineWidth', 2);
    plot(1:i, status_history.recovered, 'b', 'LineWidth', 2);
    plot(1:i, status_history.dead, 'k', 'LineWidth', 2);
    hold off;
    title('Status over Time');
    xlabel('Time Steps');
    ylabel('Number of Individuals');
    legend('Healthy', 'Infected', 'Recovered', 'Dead');

    pause(0.05);
end


%% Random "art" canvas
num_shapes = 100;
canvas = Canvas();

for i = 1:num_shapes
    shape_type = randi([1, 3]);
    if shape_type == 1
        type = 'Circle';
    elseif shape_type == 2
        type = 'Line';
    else
        type = 'Square';
    end
    position = randi([10, 90], 1, 2);
    size = randi([5, 20]);
    color = rand(1, 3);
    canvas.addShape(Shape(type, position, size, color));
end

canvas.draw();