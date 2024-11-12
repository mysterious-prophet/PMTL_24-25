classdef SimulatedAnnealing
    properties
        % Properties for the algorithm
        % Starting temperature, Cooling factor, Max. number of iterations,
        % Minimum temperature to stop, Function to minimize, Best solution
        % found, Best function value found
        initial_temp = 100;
        cooling_rate = 0.95;
        max_iters = 1000;
        min_temp = 1e-3;   
        obj_func        
        best_sol             
        best_val            
    end
    
    methods
        % Constructor to initialize the objective function and properties
        function obj = SimulatedAnnealing(obj_func, initial_temp, cooling, max_iters)
            obj.obj_func = obj_func;
            % number of input parameters
            if nargin > 1
                obj.initial_temp = initial_temp;
                obj.cooling_rate = cooling;
                obj.max_iters = max_iters;
            end
        end
        
        % Method to perform the simulated annealing optimization
        function obj = optimize(obj, initial_sol)
            % Initialize variables
            cur_sol = initial_sol;
            cur_obj = obj.obj_func(cur_sol);
            obj.best_sol = cur_sol;
            obj.best_val = cur_obj;
            temp = obj.initial_temp;
            
            % Main loop of the simulated annealing process
            for i = 1:obj.max_iters
                % Generate a neighboring solution
                new_sol = obj.neighbor(cur_sol);
                new_obj = obj.obj_func(new_sol);
                
                % Decide whether to accept the new solution, the random
                % condition is there to escape the local minima
                if new_obj < cur_obj || rand < exp((cur_obj - new_obj) / temp)
                    cur_sol = new_sol;
                    cur_obj = new_obj;
                end
                
                % Update the best solution found
                if cur_obj < obj.best_val
                    obj.best_sol = cur_sol;
                    obj.best_val = cur_obj;
                end
                
                % Cool down the temperature
                temp = temp * obj.cooling_rate;
                
                % Check stopping criteria
                if temp < obj.min_temp
                    break;
                end
            end
        end
        
        % Method to generate a neighbor solution
        function neighbor_sol = neighbor(~, solution)
            % Create a small random change in the solution
            % (Assume solution is a vector)
            perturbation = 0.1 * randn(size(solution));
            neighbor_sol = solution + perturbation;
        end
    end
end