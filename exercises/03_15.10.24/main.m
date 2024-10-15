clear; clc; close all;

%% 1. fibonacci
inp = input('Fibonacci input: ');
fib_iter = fibonacciIter(inp);
fib_recur = fibonacciRecur(inp);
% condition with "and", which is written as && for scalars in Matlab
% "or" would be || for scalars
if(~isempty(fib_iter) && ~isempty(fib_recur))
    % because fib_iter is an array, it is quicker to print it with disp()
    % function, which is analogous to python's print()
    format_spec = 'The fibonacci sequence calculated iteratively for input number %d is: \n';
    fprintf(format_spec, inp);
    disp(fib_iter);

    % sprintf creates a formatted string
    format_spec = 'The fibonacci sequence calculated recursively for input number %d is: \n';
    temp_string = sprintf(format_spec, inp);
    disp(temp_string);
    disp(fib_recur);
end

%% 2. quadratic equation
a = 1; b = 4; c = -5;
% a = 1; b = -10; c = 25;
% a = 5; b = 4; c = 10;
quad_result = quadSolver(a, b, c);
if(size(quad_result, 1) > 0)
    % %.2f is a floating point (double) number with two digits after the dot 
    format_spec = 'The solution of the quadratic equation (%.2fx^2) + (%.2fx) + (%.2f) = 0 is: ';
    fprintf(format_spec, a, b, c);
    disp(quad_result);
end

%% 3. a) Ax = b solution
m = 4;
% numbers from ~ U(0, 1)
A = rand(m, m);

sum_A = sum(sum(A));
max_A = max(max(A));
min_A = min(min(A));

b = rand(m, 1);
inv_A = inv(A);

% X = inv_A * b;
X = A \ b;

%% 3. b) random matrix and logical indexing
% notice that the "int" values are still double
A = randi([1, 100], 5, 5);
disp('Original matrix A:');
disp(A);

% logical indexing
A(A > 50) = NaN;
disp('Matrix A after replacing values > 50 with NaN:');
disp(A);

% isnan and find functions
[row, col] = find(isnan(A));
disp('Indices of NaN values:');
disp(table(row, col));

% replacing values
mean_val = mean(A(~isnan(A)));
A(isnan(A)) = mean_val;
disp('Matrix A after replacing NaNs with mean of non-NaN elements:');
disp(A);


%% 3. c) statistics, histogram, fitting
rand_vect = randn(1, 100000);

% maximum, minimum, mean, median, mode, variance, standard deviation
max_val = max(rand_vect);
min_val = min(rand_vect);
mean_val = mean(rand_vect);
median_val = median(rand_vect);
mode_val = mode(rand_vect);
var_val = var(rand_vect);
std_val = std(rand_vect);

% Display the statistics - another way, using disp and num2str, instead of fprintf
disp(["Maximum: ", num2str(max_val)]);
% in this case, there is a difference between using " and ' - while ' '
% creates an array of chars, " " creates a string, which causes a
% difference while displaying in the console, as two strings are created
disp(['Minimum: ', num2str(min_val)]);
disp(['Mean: ', num2str(mean_val)]);
disp(['Median: ', num2str(median_val)]);
disp(['Mode: ', num2str(mode_val)]);
disp(['Variance: ', num2str(var_val)]);
disp(['Standard Deviation: ', num2str(std_val)]);

% Plot the histogram of the data with 100 bins and probability density
% function estimate
figure;
histogram(rand_vect, 'NumBins', 100, "Normalization", "pdf");
hold on;

% Overlay the normal distribution with matching mean and std deviation
x = linspace(min_val, max_val, 1000);
normal_pdf = normpdf(x, mean_val, std_val);
plot(x, normal_pdf, 'r-', 'LineWidth', 2);

% Fit a normal distribution to the data using normfit
[norm_mean, norm_std] = normfit(rand_vect);

% Add text to show fitted parameters
% Dynamically determine the position for the text annotation
x_text_pos = max_val - (max_val - min_val) * 0.2;  % 20% from the right
y_text_pos = max(normal_pdf) * 0.8;  % 80% of the maximum y value

text(x_text_pos, y_text_pos, ...
    ['\mu = ', num2str(norm_mean), ', \sigma = ', num2str(norm_std)], ...
    'FontSize', 12);

title('Histogram with Normal Distribution Fit');
xlabel('Data Values');
ylabel('Probability Density');
hold off;