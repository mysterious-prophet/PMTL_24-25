% Function to simulate a 2D random walk with visual progress
% note that we can declare a function without any return variables
function randomWalk(num_steps, max_step)
    x = zeros(1, num_steps);
    y = zeros(1, num_steps);

    % Parula (blue to yellow) colormap to represent the steps
    colors = parula(num_steps);

    figure;
    hold on;
    title('2D Random Walk Simulation');
    xlabel('X Position');
    ylabel('Y Position');
    grid on;
    axis equal;
    axis([-num_steps/10 num_steps/10 -num_steps/10 num_steps/10]);

    % Plot each step with a color gradient, start at step 2 as step 1 is
    % at coordinates (0, 0)
    for i = 2:num_steps
        % if max_step is defined choose the floating point step version
        if(exist("max_step", "var"))
            % random step from [-max_step_size, max_step_size]
            step_X = (2 * rand - 1) * max_step;
            step_Y = (2 * rand - 1) * max_step;
        else
            % otherwise do a random integer step from {-1, 0, 1}
            step_X = randi([-1, 1]);
            step_Y = randi([-1, 1]);
        end

        x(i) = x(i-1) + step_X;
        y(i) = y(i-1) + step_Y;

        % Plot the step with corresponding color
        plot(x(i-1:i), y(i-1:i), 'Color', colors(i, :), 'LineWidth', 2);
        % Pause for animation effect
        pause(0.01);
    end

    % Mark the starting and ending points
    plot(x(1), y(1), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
    plot(x(end), y(end), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

    % Add a colorbar with limits for step progression
    colormap(colors);
    colorbar;
    clim([1 num_steps]);
    ylabel(colorbar, 'Step Progression');

    hold off;
end