% Person is a handle class, not a value class in this case

% As per MATLAB help:
% When you copy a value object to another variable or pass a value object 
% to a function, MATLAB creates an independent copy of the object and all 
% the data contained by the object. The new object is independent of 
% changes to the original object.

% When you copy a handle object, MATLAB copies the handle, but does not 
% copy the data stored in the object properties. The copy refers to the 
% same object as the original handle. If you change a property value on the 
% original object, the copied handle references the same change.

classdef Person < handle
    properties
        % Position on the grid
        position

        % 'Healthy', 'Infected', 'Recovered', 'Dead'
        status

        % Tracks how long a person has been infected
        inf_duration
    end

    methods
        function obj = Person(position, status)
            obj.position = position;
            obj.status = status;
            obj.inf_duration = 0;
        end

        function obj = move(obj, grid_size)
            % Random steps of size 1 in x and y directions
            delta = randi([-1, 1], 1, 2);
            obj.position = obj.position + delta;

            % Ensure position stays within bounds, if not jump to the other
            % side of the grid
            obj.position = max(min(obj.position, grid_size), 1);
        end

        function obj = updateInfection(obj, recov_time, death_prob)
            if strcmp(obj.status, 'Infected')
                obj.inf_duration = obj.inf_duration + 1;
                if obj.inf_duration >= recov_time
                    if rand < death_prob
                        obj.status = 'Dead';
                    else
                        obj.status = 'Recovered';
                    end
                end
            end
        end
    end
end