classdef SwarmSimulation
    properties
        % Number of particles in the swarm, position of each particle,
        % velocities, attraction to center, repulsion to other particles,
        % velocity aligment, maximum speed
        num_particles
        positions
        velocities
        attraction_weight = 0.01;
        repulsion_weight = 0.05;
        alignment_weight = 0.05;
        max_speed = 0.1;
    end
    
    methods
        % Constructor to initialize the swarm with random positions and velocities
        function obj = SwarmSimulation(num_particles)
            obj.num_particles = num_particles;
            % random positions and velocities
            obj.positions = rand(num_particles, 2) * 10;
            obj.velocities = rand(num_particles, 2) * 2 - 1;
        end
        
        % Method to calculate and update velocities based on swarm rules
        function obj = updateVelocities(obj)
            for i = 1:obj.num_particles
                % Get vectors for attraction to center, repulsion from close neighbors, and alignment with neighbors
                attraction = obj.calculateAttraction(i);
                repulsion = obj.calculateRepulsion(i);
                alignment = obj.calculateAlignment(i);
                
                % Update velocity based on weighted sum of behaviors
                obj.velocities(i, :) = obj.velocities(i, :) + ...
                    obj.attraction_weight * attraction + ...
                    obj.repulsion_weight * repulsion + ...
                    obj.alignment_weight * alignment;
                
                % Limit speed to max_speed
                speed = norm(obj.velocities(i, :));
                if speed > obj.max_speed
                    obj.velocities(i, :) = obj.velocities(i, :) * (obj.max_speed / speed);
                end
            end
        end
        
        % Method to update positions of particles based on velocities
        function obj = updatePositions(obj)
            obj.positions = obj.positions + obj.velocities;
        end
        
        % Method to calculate attraction towards the center
        function attraction = calculateAttraction(obj, index)
            center = mean(obj.positions, 1);  % Center of mass of the swarm
            attraction = center - obj.positions(index, :);
        end
        
        % Method to calculate repulsion to avoid crowding
        function repulsion = calculateRepulsion(obj, index)
            repulsion = [0, 0];
            for j = 1:obj.num_particles
                if j ~= index
                    distance = norm(obj.positions(j, :) - obj.positions(index, :));
                    % Repel if too close
                    if distance < 1
                        repulsion = repulsion - (obj.positions(j, :) - obj.positions(index, :)) / distance;
                    end
                end
            end
        end
        
        % Method to calculate alignment with neighboring velocities
        function alignment = calculateAlignment(obj, index)
            alignment = mean(obj.velocities, 1) - obj.velocities(index, :);
        end
    end
end