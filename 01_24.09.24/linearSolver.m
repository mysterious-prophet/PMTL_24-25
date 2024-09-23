% solver of system of linear equations, some useful matrix-related functions
% inputs: A - matrix of coefficients 
%       : b - rhs vector
% output: x - vector of solutions

%% testing system of equations
% x_1 + 2*x_2 + 3*x_3 = 6
% 4*x_1 + 5x_2 + 6x_3 = 15
% 7*x_1 + 8*x_2 + x_3 = 16
% written in the command window as
% A = [1, 2, 3; 4, 5, 6; 7, 8, 1]; 
% b = [6; 15; 16];
% it is also possible to generate a magic square matrix using A = magic(n);
% or random uniformly distributed A = rand(m, n);
% or random normally distributed A = randn(m, n);

function x = linearSolver(A, b)
    %% some useful matrix-related functions
    % determinant of A
    % det_A = det(A); 
    % transpose of A
    % trans_A = A';
    % inverse of A
    % inv_A = inv(A); 
    % sum of rows of A
    % sum_rows = sum(A); 
    % sum of columns of A
    % sum_cols = sum(trans_A);  
    % maximum of A, note the double use of max - first we obtain the
    % maximums along the rows and then the maximum element
    % max_A = max(max(A));
    % minimum of A
    % min_A = min(min(A));
    % sum of all elements of A
    % sum_A = sum(sum(A));

    %% submatrix
    % accessing elements of matrix
    % contains first two rows and all columns
    % sub_A = A(1:2, :);  
    % contains first row and last two columns, note the use of end keyword
    % sub_A_1 = A(1, 2:end);
   
    %% calculate solution of system of linear equations
    % if condition, note the ~= not equal notation
    if(det(A) ~= 0)
        % possible
        % x = inv(A)*b;
        % but Matlab prefers mldivide(A, b) also possible to write as A\b 
        x = A\b;
    else
        % display simple, unformated message to command window
        disp('No solution!');
    end
end