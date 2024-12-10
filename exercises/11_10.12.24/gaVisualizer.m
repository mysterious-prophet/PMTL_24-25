function gaVisualizer
    clear; clc; close all;

    % Initialize parameters - number of individuals in each generation,
    % number of generations, mutations rate and scale (for Rosenbrock, see below), 
    % length of chromosomes, current generation index, array containing best fitness in each generation,
    % elitism boolean, default crossover type and fitness function

    % You can try and check the difference the input parameters make for
    % different optimization problems. Bit maximization will work better
    % with low mutation rate <= 0.05
    params.pop_size = 100;
    params.num_gens = 250;
    params.mut_rate = 0.05;
    params.mut_scale = 0.3;
    params.chrom_length = 50;
    params.curr_gen = 0;
    params.best_fit = [];
    params.best_individual = [];
    params.elitism = true;
    params.crossover = 'Single-Point';
    params.fitness_func = 'Maximize Bits';

    % Create main window
    fig = figure('Name', 'Genetic Algorithm Visualizer', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 1000, 700], ...
                 'Resize', 'off', ...
                 'CloseRequestFcn', @closeGui);

    % Fitness plot
    ax = axes('Parent', fig, ...
              'Position', [0.1, 0.55, 0.8, 0.35]);
    hold(ax, 'on');
    xlabel(ax, 'Generation');
    ylabel(ax, 'Fitness');
    title(ax, 'Fitness Progress');

    % Control panel
    uicontrol('Style', 'text', 'String', 'Population Size:', ...
              'Position', [50, 330, 120, 20], 'HorizontalAlignment', 'right');
    population_size_input = uicontrol('Style', 'edit', 'String', params.pop_size, ...
                                      'Position', [180, 330, 50, 20]);

    uicontrol('Style', 'text', 'String', 'Generations:', ...
              'Position', [50, 290, 120, 20], 'HorizontalAlignment', 'right');
    generations_input = uicontrol('Style', 'edit', 'String', params.num_gens, ...
                                  'Position', [180, 290, 50, 20]);

    uicontrol('Style', 'text', 'String', 'Mutation Rate:', ...
              'Position', [50, 250, 120, 20], 'HorizontalAlignment', 'right');
    mutation_rate_input = uicontrol('Style', 'edit', 'String', params.mut_rate, ...
                                    'Position', [180, 250, 50, 20]);

    uicontrol('Style', 'text', 'String', 'Fitness Function:', ...
              'Position', [50, 210, 120, 20], 'HorizontalAlignment', 'right');
    fitness_function_dropdown = uicontrol('Style', 'popupmenu', ...
                                          'String', {'Maximize Bits', 'Rosenbrock'}, ...
                                          'Position', [180, 210, 150, 20]);

    uicontrol('Style', 'text', 'String', 'Crossover Method:', ...
              'Position', [50, 170, 120, 20], 'HorizontalAlignment', 'right');
    crossover_dropdown = uicontrol('Style', 'popupmenu', ...
                                   'String', {'Single-Point', 'Two-Point', 'Uniform'}, ...
                                   'Position', [180, 170, 150, 20]);

    elitism_checkbox = uicontrol('Style', 'checkbox', ...
                                 'String', 'Enable Elitism', ...
                                 'Position', [150, 130, 150, 20], ...
                                 'Value', 1);

    % Best fitness displays
    uicontrol('Style', 'text', 'String', 'Best Curr. Gen. Fitness:', ...
              'Position', [400, 300, 100, 40], 'HorizontalAlignment', 'right');
    best_cur_fit_text = uicontrol('Style', 'text', 'String', 'N/A', ...
                                     'Position', [500, 300, 50, 40]);

    uicontrol('Style', 'text', 'String', 'Best Overall Fitness:', ...
              'Position', [400, 260, 100, 30], 'HorizontalAlignment', 'right');
    best_overall_fit_text = uicontrol('Style', 'text', 'String', 'N/A', ...
                                  'Position', [500, 260, 50, 30]);

    uicontrol('Style', 'text', 'String', 'Best Overall Individual:', ...
        'Position', [400 220 100 40], 'HorizontalAlignment', 'right');
    best_individual_text = uicontrol('Style', 'text', 'String', 'N/A', ...
        'Position', [510 220 450 50]);

    % Start and Stop buttons
    start_btn = uicontrol('Style', 'pushbutton', 'String', 'Start', ...
                          'Position', [400, 170, 100, 30], ...
                          'Callback', @startGa);

    % Default enable values to off
    stop_btn = uicontrol('Style', 'pushbutton', 'String', 'Stop', ...
                         'Position', [510, 170, 100, 30], ...
                         'Callback', @stopGa, 'Enable', 'off');

    save_results_btn = uicontrol('Style', 'pushbutton', 'String', 'Save Results', ...
                                 'Position', [620, 170, 100, 30], ...
                                 'Callback', @saveResults, 'Enable', 'off');

    % Internal state
    is_running = false;

    % Start GA function
    function startGa(~, ~)
        % Update parameters
        params.pop_size = str2double(population_size_input.String);
        params.num_gens = str2double(generations_input.String);
        params.mut_rate = str2double(mutation_rate_input.String);
        params.elitism = elitism_checkbox.Value;
        params.fitness_func = fitness_function_dropdown.String{fitness_function_dropdown.Value};
        params.crossover = crossover_dropdown.String{crossover_dropdown.Value};

        % Validate inputs
        if isnan(params.pop_size) || params.pop_size <= 0
            errordlg('Invalid population size.');
            return;
        end
        if isnan(params.num_gens) || params.num_gens <= 0
            errordlg('Invalid number of generations.');
            return;
        end
        if isnan(params.mut_rate) || params.mut_rate < 0 || params.mut_rate > 1
            errordlg('Mutation rate must be between 0 and 1.');
            return;
        end

        % Initialize GA
        params.curr_gen = 0;
        params.best_fit = [];

        switch params.fitness_func
            case 'Maximize Bits'
                % Maximize the sum of bits in each chromosome
                population = randi([0, 1], params.pop_size, params.chrom_length);
            case 'Rosenbrock'
                % Rosenbrock function
                lower_bound = -5;
                upper_bound = 5;
                population = lower_bound + (upper_bound - lower_bound) * rand(params.pop_size, params.chrom_length);
            otherwise
                error('Unknown fitness function.');
        end
        is_running = true;
        start_btn.Enable = 'off';
        stop_btn.Enable = 'on';
        save_results_btn.Enable = 'off';
        

        % Run GA loop
        while is_running && params.curr_gen < params.num_gens
            pause(0.1); % Simulate processing time
            params.curr_gen = params.curr_gen + 1;

            % Evaluate fitness
            fitness = evaluateFitness(population, params.fitness_func);
            [cur_max_fitness, idx] = max(fitness);
            params.best_fit = [params.best_fit, cur_max_fitness];

            % Update GUI
            if(cur_max_fitness >= max(params.best_fit))
                params.best_individual = population(idx, :);
                best_overall_fit_text.String = sprintf('%.2f', cur_max_fitness);
                best_individual_text.String = mat2str(population(idx, :));
            end
            best_cur_fit_text.String = sprintf('%.2f', cur_max_fitness);

            % Plot fitness progress
            plot(ax, 1:params.curr_gen, params.best_fit, '-o', 'LineWidth', 1.5);

            % Selection, crossover, and mutation
            population = nextGeneration(population, fitness, params);
        end

        % Finalize
        is_running = false;
        start_btn.Enable = 'on';
        stop_btn.Enable = 'off';
        save_results_btn.Enable = 'on';
    end

    % Stop GA function
    function stopGa(~, ~)
        is_running = false;
    end

    % Evaluate fitness function
    function fitness = evaluateFitness(population, fitness_function)
        switch fitness_function
            case 'Maximize Bits'
                % Maximize the sum of bits in each chromosome
                % Maximum at chromosome length
                fitness = sum(population, 2);
            case 'Rosenbrock'
                % Use Rosenbrock function defined below
                % Maximum at 0
                fitness = rosenbrock(population);
            otherwise
                error('Unknown fitness function.');
        end
    end

    % Generate next generation
    function new_population = nextGeneration(population, fitness, params)
        % Initialize new population
        new_population = zeros(size(population));
        num_individuals = size(population, 1);
    
        % Elitism: Preserve the best individual
        % This is a very simple example of elitism, where only the single
        % best individual gets preserved. Generally, some percentage of best
        % individuals is used in real case scenarios
        if params.elitism
            [~, best_idx] = max(fitness);
            new_population(1, :) = population(best_idx, :);
            % Start new population from the second individual
            start_idx = 2;
        else
            % Start new population from the first individual
            start_idx = 1;
        end

        % Rank-Based Selection
        [~, sorted_indices] = sort(fitness, 'descend');
        rank_probabilities = linspace(1, 0, num_individuals);
        rank_probabilities = rank_probabilities / sum(rank_probabilities);
        
        % Select individuals based on rank probabilities
        selected_idx = randsample(sorted_indices, num_individuals, true, rank_probabilities);
    
        % Generate offspring
        for i = start_idx:2:num_individuals
            % If out of bounds
            if i + 1 > num_individuals
                % The last individual could be all zeros if not defined
                % here
                parent1 = population(selected_idx(i - 1), :);
                parent2 = population(selected_idx(i), :);
                child1 = 0.5 * (parent1 + parent2);
                new_population(i, :) = child1;
                break;
            end

            % Parents
            parent1 = population(selected_idx(i), :);
            parent2 = population(selected_idx(i + 1), :);
    
            % Crossover
            switch params.crossover
                case 'Single-Point'
                    crossover_point = randi([1, params.chrom_length - 1]);
                    child1 = [parent1(1:crossover_point), parent2(crossover_point + 1:end)];
                    child2 = [parent2(1:crossover_point), parent1(crossover_point + 1:end)];
                case 'Two-Point'
                    points = sort(randi([1, params.chrom_length - 1], 1, 2));
                    % e.g. 1 . . p1 . . . p2 . . end
                    child1 = [parent1(1:points(1)), parent2(points(1)+1:points(2)), parent1(points(2)+1:end)];
                    child2 = [parent2(1:points(1)), parent1(points(1)+1:points(2)), parent2(points(2)+1:end)];
                case 'Uniform'
                    mask = rand(1, params.chrom_length) > 0.5;
                    child1 = parent1;
                    child2 = parent2;
                    % Random uniform mix
                    child1(mask) = parent2(mask);
                    child2(mask) = parent1(mask);
            end
    
            % Add children to the new population
            new_population(i, :) = child1;
            new_population(i + 1, :) = child2;
        end
    
        % Mutation
        mutation_mask = rand(size(new_population)) < params.mut_rate;
        switch params.fitness_func
            case "Maximize Bits"
                new_population = xor(new_population, mutation_mask);
            case "Rosenbrock"
                % Apply random perturbation to genes selected for mutation
                mutation_perturbation = params.mut_scale * (2 * rand(size(population)) - 1);               
                % Mutate the population
                new_population = new_population + mutation_mask .* mutation_perturbation;
        end
    end

    % Function to save results to a CSV file
    function saveResults(~, ~)
        [file, path] = uiputfile({'*.csv', 'CSV Files (*.csv)'}, 'Save Results');
        
        % If the user cancels
        if isequal(file, 0)
            return;
        end
    
        % Construct the full file path
        file_path = fullfile(path, file);
        
        try
            % Save the best fitness values over generations to a CSV file
            csvwrite(file_path, params.best_fit');
            msgbox('Results saved successfully!', 'Success');
        catch error
            % Display an error message if saving fails
            errordlg(['Failed to save results: ', error.message], 'Error');
        end
    end

    % Close GUI safely
    function closeGui(~, ~)
        is_running = false;
        delete(fig);
    end
end

function fitness = rosenbrock(population)
    % -\sum-{i=1}^{n-1}(100*(x_{i+1}-x_{i}^2)^2+(1-x_{i})^2)
    % Maximum at 0
    fitness = -sum(100 * (population(:, 2:end) - population(:, 1:end-1).^2).^2 + ...
                   (1 - population(:, 1:end-1)).^2, 2);
end

