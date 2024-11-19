classdef MarkovChainTextGenerator
    properties
        % Markov chain as a map of word transitions, 
        % Order of the Markov chain (number of words in each state)
        chain
        order
    end
    
    methods
        % Constructor to initialize the Markov chain
        function obj = MarkovChainTextGenerator(order)
            if nargin < 1 || ~isscalar(order) || order <= 0
                error('Order must be a positive scalar integer.');
            end
            % containers.Map() is equivalent to dict in Python
            obj.chain = containers.Map();
            obj.order = order;
        end
        
        % Method to train the Markov chain with input text
        function obj = train(obj, input_text)
            if ~ischar(input_text) && ~isstring(input_text)
                error('Input text must be a character array or string.');
            end
            
            % split input text to lowercase words
            words = split(lower(input_text));
            num_words = numel(words);
            
            if num_words <= obj.order
                error('Input text must have more words than the Markov chain order.');
            end
            
            for i = 1:(num_words - obj.order)
                % Create the current state based on the specified order
                state = strjoin(words(i:i+obj.order-1));
                
                % Get the next word after the current state
                next_word = words{i + obj.order};
                
                % Update the chain, ensuring no duplicate transitions
                if isKey(obj.chain, state)
                    if ~ismember(next_word, obj.chain(state))
                        obj.chain(state) = [obj.chain(state), {next_word}];
                    end
                else
                    obj.chain(state) = {next_word};
                end
            end
        end
        
        % Method to generate text using the trained Markov chain
        function output = generateText(obj, num_words)
            if ~isscalar(num_words) || num_words <= obj.order
                error('Number of words must be greater than the Markov chain order.');
            end
            
            keys = obj.chain.keys;
            if isempty(keys)
                error('The Markov chain is empty. Train it before generating text.');
            end
            
            % Random starting state
            state = keys{randi(length(keys))};
            % Initialize output with the start state
            output_words = split(state);
            
            % Generate new words based on the chain
            for i = 1:(num_words - obj.order)
                if isKey(obj.chain, state)
                    next_words = obj.chain(state);
                    next_word = next_words{randi(length(next_words))};
                    output_words = [output_words; next_word];
                    
                    % Update the state to the next sequence of words
                    state_words = split(state);
                    state = strjoin([state_words(2:end); next_word]); 
                else
                    % If no further transition possible, stop generation
                    break;
                end
            end  
            % Combine generated words into the output string
            output = strjoin(output_words');
        end
    end
end
