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
            % obj.population = obj.initializePopulation();
        end
    end
end