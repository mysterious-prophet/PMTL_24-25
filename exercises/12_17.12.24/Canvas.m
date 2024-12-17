classdef Canvas < handle
    properties
        shapes
    end
    
    methods
        function obj = Canvas()
            obj.shapes = [];
        end

        function addShape(obj, shape)
            obj.shapes = [obj.shapes, shape];
        end

        function draw(obj)
            clf;
            for i = 1:numel(obj.shapes)
                obj.shapes(i).draw();
            end
            axis equal;
        end
    end
end