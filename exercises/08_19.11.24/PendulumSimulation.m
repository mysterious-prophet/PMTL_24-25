classdef PendulumSimulation
    properties
        % pendulum lenght, mass, angle, angular velocity; gravity, time
        % step, damping factor
        length
        mass
        angle
        angular_vel
        gravity
        time_step
        damping
    end
    
    methods
        % Constructor to initialize pendulum parameters
        function obj = PendulumSimulation(length, mass, angle, ang_vel, gravity, time_step, damping)
            obj.length = length;
            obj.mass = mass;
            obj.angle = angle;
            obj.angular_vel = ang_vel;
            obj.gravity = gravity;
            obj.time_step = time_step;
            obj.damping = damping;
        end
        
        % Method to simulate and animate the pendulum
        function simulate(obj, duration)
            % Initialize the figure for animation
            figure;
            axis equal;
            axis([-obj.length, obj.length, -obj.length, obj.length]);
            hold on;
            title('Pendulum Simulation');
            xlabel('X Position (m)');
            ylabel('Y Position (m)');
            
            % Set up the line and the ball for animation
            pendulum_line = line([0, obj.length * sin(obj.angle)], [0, -obj.length * cos(obj.angle)], 'LineWidth', 2);
            pendulum_ball = plot(obj.length * sin(obj.angle), -obj.length * cos(obj.angle), 'o', 'MarkerSize', 12, 'MarkerFaceColor', 'b');
            
            % Simulation loop
            time = 0;
            while time < duration
                % Calculate angular acceleration
                angular_acc = -(obj.gravity / obj.length) * sin(obj.angle) - obj.damping * obj.angular_vel;
                
                % Update angular velocity and angle
                obj.angular_vel = obj.angular_vel + angular_acc * obj.time_step;
                obj.angle = obj.angle + obj.angular_vel * obj.time_step;
                
                % Update the pendulum position
                x = obj.length * sin(obj.angle);
                y = -obj.length * cos(obj.angle);
                
                % Update the line and the ball for animation
                set(pendulum_line, 'XData', [0, x], 'YData', [0, y]);
                set(pendulum_ball, 'XData', x, 'YData', y);
                
                % Pause for a short duration to display the animation
                pause(obj.time_step);
                
                % Increment time
                time = time + obj.time_step;
            end
        end
    end
end
