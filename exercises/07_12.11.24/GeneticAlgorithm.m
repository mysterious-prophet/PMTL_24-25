classdef GeneticAlgorithm
    properties
        % number of individuals in the population
        population_size
        % number of population generations generated
        num_gens
        % rate of mutation in each generation
        mutation_rate
        % the number of parameters of each individual
        chromosome_length
        % population of the current generation
        population
        % maximum fitness achieved
        max_fitness = 0
        best_generation = 1;
    end
    
    methods
        % Constructor to initialize the properties
        function obj = GeneticAlgorithm(pop_size, num_gen, mut_rate, chrom_len)
            obj.population_size = pop_size;
            obj.num_gens = num_gen;
            obj.mutation_rate = mut_rate;
            obj.chromosome_length = chrom_len;
            obj.population = obj.initializePopulation();
        end

        % Destructor method
        function delete(obj)
            disp('GeneticAlgorithm object is being deleted.');
        end
        
        % Initialize the population with random binary chromosomes
        % Non-static methods have to have obj as the first argument
        function pop = initializePopulation(obj)
            pop = randi([0, 1], obj.population_size, obj.chromosome_length);
        end
        
        % Fitness function: example of maximizing the sum of bits
        % obj is ~ here, as it is not used inside the method
        function fitness = evaluateFitness(~, chromosome)
            fitness = sum(chromosome);
        end
        
        % Crossover function: single-point crossover
        function [child1, child2] = crossover(~, parent1, parent2)
            cross_point = randi([1, length(parent1) - 1]);
            child1 = [parent1(1:cross_point), parent2(cross_point+1:end)];
            child2 = [parent2(1:cross_point), parent1(cross_point+1:end)];
        end
        
        % Mutation function
        function mutated_chromosome = mutate(obj, chromosome)
            for i = 1:length(chromosome)
                if rand < obj.mutation_rate
                    chromosome(i) = ~chromosome(i);
                end
            end
            mutated_chromosome = chromosome;
        end
        
        % Run the genetic algorithm
        function run(obj)
            for gen = 1:obj.num_gens
                % Evaluate fitness for all individuals by using arrayfun,
                % which applies the function evaluateFitness to every
                % individual in the population
                fitness_scores = arrayfun(@(i) obj.evaluateFitness(obj.population(i, :)), 1:obj.population_size);
                
                % Selection: roulette wheel
                total_fitness = sum(fitness_scores);
                selection_prob = fitness_scores / total_fitness;
                cum_prob = cumsum(selection_prob);
                
                % Create the next generation
                new_population = zeros(size(obj.population));
                for i = 1:2:obj.population_size
                    % Select parents randomly
                    parent1 = obj.population(find(cum_prob > rand, 1), :);
                    parent2 = obj.population(find(cum_prob > rand, 1), :);
                    
                    % Crossover
                    [child1, child2] = obj.crossover(parent1, parent2);
                    
                    % Mutation
                    new_population(i, :) = obj.mutate(child1);
                    if i+1 <= obj.population_size
                        new_population(i+1, :) = obj.mutate(child2);
                    end
                end
                
                % Update population
                obj.population = new_population;
                
                % Print best fitness of this generation
                cur_max_fitness = max(fitness_scores);
                if(cur_max_fitness > obj.max_fitness)
                    obj.max_fitness = cur_max_fitness;
                    obj.best_generation = gen;
                end
                fprintf('Generation %d: Best Fitness = %d\n', gen, cur_max_fitness);
            end
            fprintf('Maximum Fitness = %d in generation: %d\n', obj.max_fitness, obj.best_generation);
        end
    end

    % example of a static/class method
    methods(Static)
        % Static method to generate a random binary chromosome of a given length
        function chromosome = generateRandomChromosome(length)
            chromosome = randi([0, 1], 1, length);
        end
    end
end