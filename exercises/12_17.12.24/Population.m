% Population is a value class

% As per MATLAB help:
% When you copy a value object to another variable or pass a value object 
% to a function, MATLAB creates an independent copy of the object and all 
% the data contained by the object. The new object is independent of 
% changes to the original object.

% When you copy a handle object, MATLAB copies the handle, but does not 
% copy the data stored in the object properties. The copy refers to the 
% same object as the original handle. If you change a property value on the 
% original object, the copied handle references the same change.

classdef Population
    properties
        individuals
        grid_size
        inf_rate
        recov_time
        death_prob
    end

    methods
        function obj = Population(num_inds, grid_size, inf_rate, recov_time, death_prob)
            obj.grid_size = grid_size;
            obj.inf_rate = inf_rate;
            obj.recov_time = recov_time;
            obj.death_prob = death_prob;
            obj.individuals = cell(num_inds, 1);

            % Initialize individuals
            for i = 1:num_inds
                obj.individuals{i} = Person(randi(grid_size, 1, 2), 'Healthy');
            end
            % Patient zero
            obj.individuals{randi(num_inds)}.status = 'Infected';
        end

        function spreadInfection(obj, inf_radius)
            for i = 1:numel(obj.individuals)
                if strcmp(obj.individuals{i}.status, 'Infected')
                    for j = 1:numel(obj.individuals)
                        if strcmp(obj.individuals{j}.status, 'Healthy')
                            distance = sqrt(sum((obj.individuals{i}.position - obj.individuals{j}.position).^2));
                            if distance <= inf_radius && rand < obj.inf_rate
                                obj.individuals{j}.status = 'Infected';
                                obj.individuals{j}.inf_duration = 0;
                            end
                        end
                    end
                end
            end
        end

        function moveIndividuals(obj)
            for i = 1:numel(obj.individuals)
                % This is not a zombie virus, the dead don't walk
                if ~strcmp(obj.individuals{i}.status, 'Dead')
                    obj.individuals{i}.move(obj.grid_size);
                end
            end
        end

        function updateStatuses(obj)
            for i = 1:numel(obj.individuals)
                obj.individuals{i}.updateInfection(obj.recov_time, obj.death_prob);
            end
        end

        function counts = countStatuses(obj)
            counts.healthy = sum(cellfun(@(x) strcmp(x.status, 'Healthy'), obj.individuals));
            counts.infected = sum(cellfun(@(x) strcmp(x.status, 'Infected'), obj.individuals));
            counts.recovered = sum(cellfun(@(x) strcmp(x.status, 'Recovered'), obj.individuals));
            counts.dead = sum(cellfun(@(x) strcmp(x.status, 'Dead'), obj.individuals));
        end

        function displayPopulation(obj)
            subplot(1, 2, 1);
            cla;
            hold on;

            for i = 1:numel(obj.individuals)
                if strcmp(obj.individuals{i}.status, 'Healthy')
                    plot(obj.individuals{i}.position(1), obj.individuals{i}.position(2), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
                elseif strcmp(obj.individuals{i}.status, 'Infected')
                    plot(obj.individuals{i}.position(1), obj.individuals{i}.position(2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
                elseif strcmp(obj.individuals{i}.status, 'Recovered')
                    plot(obj.individuals{i}.position(1), obj.individuals{i}.position(2), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
                elseif strcmp(obj.individuals{i}.status, 'Dead')
                    plot(obj.individuals{i}.position(1), obj.individuals{i}.position(2), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
                end
            end

            title('Population Movement');
            axis([1 obj.grid_size 1 obj.grid_size]);
            hold off;
        end
    end
end