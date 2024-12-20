function matrixVisualizer
    % Clear workspace and close figures
    clear; clc; close all;

    % Create the main window
    fig = figure('Units', 'Normalized', ...
                 'Position', [0.3, 0.3, 0.4, 0.6], ...
                 'Name', 'Matrix Visualizer', ...
                 'NumberTitle', 'off', ...
                 'MenuBar', 'none', ...
                 'Resize', 'off');

    % Create axes for the plot
    ax = axes('Parent', fig, ...
              'Units', 'Normalized', ...
              'Position', [0.1, 0.4, 0.8, 0.5]);

    % Create label and input field for matrix entry
    uicontrol('Parent', fig, ...
              'Style', 'text', ...
              'Units', 'Normalized', ...
              'Position', [0.1, 0.25, 0.3, 0.05], ...
              'String', 'Enter Matrix:', ...
              'FontSize', 12, ...
              'HorizontalAlignment', 'left');

    matrix_input = uicontrol('Parent', fig, ...
                            'Style', 'edit', ...
                            'Units', 'Normalized', ...
                            'Position', [0.4, 0.25, 0.5, 0.05], ...
                            'FontSize', 12);

    % Create label and dropdown menu for visualization type
    uicontrol('Parent', fig, ...
              'Style', 'text', ...
              'Units', 'Normalized', ...
              'Position', [0.1, 0.15, 0.3, 0.05], ...
              'String', 'Visualization Type:', ...
              'FontSize', 12, ...
              'HorizontalAlignment', 'left');

    vis_type_dropdown = uicontrol('Parent', fig, ...
                                 'Style', 'popupmenu', ...
                                 'Units', 'Normalized', ...
                                 'Position', [0.4, 0.15, 0.5, 0.05], ...
                                 'String', {'Heatmap', 'Surface Plot', 'Bar Plot'}, ...
                                 'FontSize', 12, ...
                                 'Callback', @(src, ~) updateVisualization(matrix_input, ax, src));

    % Add a button to load matrix from file
    uicontrol('Parent', fig, ...
              'Style', 'pushbutton', ...
              'Units', 'Normalized', ...
              'Position', [0.1, 0.05, 0.35, 0.05], ...
              'String', 'Load Matrix from File', ...
              'FontSize', 12, ...
              'Callback', @(~, ~) loadMatrixFromFile(matrix_input));

    % Add a button to visualize the matrix
    uicontrol('Parent', fig, ...
              'Style', 'pushbutton', ...
              'Units', 'Normalized', ...
              'Position', [0.55, 0.05, 0.35, 0.05], ...
              'String', 'Visualize', ...
              'FontSize', 12, ...
              'Callback', @(~, ~) updateVisualization(matrix_input, ax, vis_type_dropdown));
end

% Function to update visualization
function updateVisualization(matrix_input, ax, vis_type_dropdown)
    % Get the matrix from the input field
    try
        % Matlab recommends str2double, but that would not work
        matrix = str2num(matrix_input.String);
        if isempty(matrix)
            error('Invalid matrix format');
        end
    catch
        errordlg('Invalid matrix. Please enter a valid numerical matrix.', 'Error');
        return;
    end

    % Clear the axes
    cla(ax);

    % Get the selected visualization type
    vis_type = vis_type_dropdown.String{vis_type_dropdown.Value};

    % Plot based on the selected visualization type
    switch vis_type
        case 'Heatmap'
            imagesc(ax, matrix);
            colorbar(ax);
            title(ax, 'Heatmap');
        case 'Surface Plot'
            surf(ax, matrix);
            title(ax, '3D Surface Plot');
        case 'Bar Plot'
            bar3(ax, matrix);
            title(ax, 'Bar Plot');
    end
end

% Function to load matrix from a file
function loadMatrixFromFile(matrix_input)
    % Open file dialog
    [file, path] = uigetfile({'*.mat;*.txt;*.csv', 'Matrix Files (*.mat, *.txt, *.csv)'});

    % if user cancels the dialog
    if isequal(file, 0)
        return;
    end

    % Get the file extension
    [~, ~, ext] = fileparts(file);

    % Load the matrix
    try
        switch ext
            case '.mat'
                data = load(fullfile(path, file));
                matrix = struct2array(data);
            case '.txt'
                matrix = dlmread(fullfile(path, file));
            case '.csv'
                matrix = csvread(fullfile(path, file));
            otherwise
                error('Unsupported file format');
        end
        % Set the loaded matrix in the input field
        matrix_input.String = mat2str(matrix);
    catch
        errordlg('Failed to load the matrix from the file.', 'Error');
    end
end