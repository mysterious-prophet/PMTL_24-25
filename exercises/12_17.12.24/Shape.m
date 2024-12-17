classdef Shape
    properties
        % 'Circle', 'Line', 'Square'
        type
        position
        size
        color
    end

    methods
        function obj = Shape(type, position, size, color)
            obj.type = type;
            obj.position = position;
            obj.size = size;
            obj.color = color;
        end

        function draw(obj)
            hold on;
            if strcmp(obj.type, 'Circle')
                rectangle('Position', [obj.position - obj.size/2, obj.size, obj.size], 'Curvature', [1, 1], 'FaceColor', obj.color);
            elseif strcmp(obj.type, 'Line')
                line([obj.position(1), obj.position(1) + obj.size], [obj.position(2), obj.position(2)], 'Color', obj.color, 'LineWidth', 2);
            elseif strcmp(obj.type, 'Square')
                rectangle('Position', [obj.position - obj.size/2, obj.size, obj.size], 'Curvature', [0, 0], 'FaceColor', obj.color);
            end
            hold off;
        end
    end
end