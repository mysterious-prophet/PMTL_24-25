% Main function, you can see the definition of variables with scope that
% also spans the nested functions
function interactivePlotter
    % Clear workspace and close all figures
    clear; clc; close all;

    % Create the main GUI window
    fig = figure('Name', 'Interactive Data Plotter', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 1100, 700], ...
                 'Resize', 'off', ...
                 'Color', [0.94, 0.94, 0.94]); % Light gray background

    % Axes
    ax = axes('Parent', fig, ...
              'Position', [0.1, 0.45, 0.8, 0.5], ...
              'Box', 'on');
    xlabel(ax, 'X');
    ylabel(ax, 'Y');
    title(ax, 'Data Plot');
    grid(ax, 'on');

    % Control Panel Title
    uicontrol('Style', 'text', ...
              'String', 'Control Panel', ...
              'FontSize', 12, ...
              'FontWeight', 'bold', ...
              'HorizontalAlignment', 'center', ...
              'BackgroundColor', [0.94, 0.94, 0.94], ...
              'Position', [50, 180, 1000, 30]);

    % Control Panel dropdowns for X and Y selection
    uicontrol('Style', 'text', 'String', 'X:', ...
              'Position', [50, 140, 100, 20], ...
              'HorizontalAlignment', 'left', 'FontSize', 10, ...
              'BackgroundColor', [0.94, 0.94, 0.94]);
    x_dropdown = uicontrol('Style', 'popupmenu', ...
                           'String', {'Select X'}, ...
                           'Position', [150, 140, 150, 25], ...
                           'Callback', @updatePlot);

    uicontrol('Style', 'text', 'String', 'Y:', ...
              'Position', [50, 100, 100, 20], ...
              'HorizontalAlignment', 'left', 'FontSize', 10, ...
              'BackgroundColor', [0.94, 0.94, 0.94]);
    y_dropdown = uicontrol('Style', 'popupmenu', ...
                           'String', {'Select Y'}, ...
                           'Position', [150, 100, 150, 25], ...
                           'Callback', @updatePlot);

    % Plot Type
    uicontrol('Style', 'text', 'String', 'Plot Type:', ...
              'Position', [50, 60, 100, 20], ...
              'HorizontalAlignment', 'left', 'FontSize', 10, ...
              'BackgroundColor', [0.94, 0.94, 0.94]);
    plot_type_dropdown = uicontrol('Style', 'popupmenu', ...
                                   'String', {'Line', 'Scatter', 'Bar'}, ...
                                   'Position', [150, 60, 150, 25], ...
                                   'Callback', @updatePlot);

    % Axis Limits for X
    uicontrol('Style', 'text', 'String', 'X Limits:', ...
              'Position', [350, 140, 100, 20], ...
              'HorizontalAlignment', 'left', 'FontSize', 10, ...
              'BackgroundColor', [0.94, 0.94, 0.94]);
    x_min_input = uicontrol('Style', 'edit', 'String', 'Auto', ...
                            'Position', [450, 140, 60, 25], ...
                            'Callback', @updatePlot);
    x_max_input = uicontrol('Style', 'edit', 'String', 'Auto', ...
                            'Position', [520, 140, 60, 25], ...
                            'Callback', @updatePlot);

    % Axis Limits for Y
    uicontrol('Style', 'text', 'String', 'Y Limits:', ...
              'Position', [350, 100, 100, 20], ...
              'HorizontalAlignment', 'left', 'FontSize', 10, ...
              'BackgroundColor', [0.94, 0.94, 0.94]);
    y_min_input = uicontrol('Style', 'edit', 'String', 'Auto', ...
                            'Position', [450, 100, 60, 25], ...
                            'Callback', @updatePlot);
    y_max_input = uicontrol('Style', 'edit', 'String', 'Auto', ...
                            'Position', [520, 100, 60, 25], ...
                            'Callback', @updatePlot);

    % Buttons (Load and Save, moved down)
    load_btn = uicontrol('Style', 'pushbutton', 'String', 'Load Data', ...
                         'Position', [650, 140, 100, 30], ...
                         'Callback', @loadData, ...
                         'BackgroundColor', [0.8, 0.8, 0.8], ...
                         'FontSize', 10);

    save_btn = uicontrol('Style', 'pushbutton', 'String', 'Save Plot', ...
                         'Position', [650, 100, 100, 30], ...
                         'Callback', @savePlot, ...
                         'BackgroundColor', [0.8, 0.8, 0.8], ...
                         'FontSize', 10);

    % Data storage
    data = [];
    column_names = {};

    function loadData(~, ~)
        % Open a dialog box to select a .csv file
        [file, path] = uigetfile({'*.csv', 'CSV Files (*.csv)'}, 'Load Data');
        % If user closes dialog without selecting a file
        if isequal(file, 0)
            return; 
        end

        try
            % Read data table from file
            data = readtable(fullfile(path, file));
            column_names = data.Properties.VariableNames;

            % Update dropdown menus
            x_dropdown.String = [{'Select X'}, column_names];
            y_dropdown.String = [{'Select Y'}, column_names];

            % Clear axes, reset plot
            cla(ax);
            xlabel(ax, 'X');
            ylabel(ax, 'Y');
            title(ax, 'Data Plot');
            grid(ax, 'on');
        catch error
            errordlg(['Failed to load data: ', error.message], 'Error');
        end
    end

    function savePlot(~, ~)
        % save file as
        [file, path] = uiputfile({'*.png;*.jpg;*.fig', 'Image Files (*.png, *.jpg, *.fig)'}, 'Save Plot');
        if isequal(file, 0)
            return; 
        end

        try
            saveas(ax, fullfile(path, file));
            msgbox('Plot saved successfully!', 'Success');
        catch error
            errordlg(['Failed to save plot: ', error.message], 'Error');
        end
    end

    function updatePlot(~, ~)
        if isempty(data)
            errordlg('Please load data first.', 'Error');
            return;
        end

        % Get selected columns
        x_idx = x_dropdown.Value - 1;
        y_idx = y_dropdown.Value - 1;

        % Invalid column selection
        if x_idx < 1 || y_idx < 1
            return;
        end

        x_data = data{:, x_idx};
        y_data = data{:, y_idx};

        % Plot based on selected type, clear axes
        plot_type = plot_type_dropdown.String{plot_type_dropdown.Value};
        cla(ax);

        switch plot_type
            case 'Line'
                plot(ax, x_data, y_data, '-o');
            case 'Scatter'
                scatter(ax, x_data, y_data, 'filled');
            case 'Bar'
                bar(ax, x_data, y_data);
        end

        xlabel(ax, column_names{x_idx});
        ylabel(ax, column_names{y_idx});
        title(ax, [column_names{y_idx} ' vs. ' column_names{x_idx}]);

        % Update axis limits
        updateAxisLimits();
    end

    function updateAxisLimits()
        try
            % Case-insensitive string compare
            if strcmpi(x_min_input.String, 'Auto') || strcmpi(x_max_input.String, 'Auto')
                xlim(ax, 'auto');
            else
                xlim(ax, [str2double(x_min_input.String), str2double(x_max_input.String)]);
            end
        catch
            xlim(ax, 'auto');
        end

        try
            if strcmpi(y_min_input.String, 'Auto') || strcmpi(y_max_input.String, 'Auto')
                ylim(ax, 'auto');
            else
                ylim(ax, [str2double(y_min_input.String), str2double(y_max_input.String)]);
            end
        catch
            ylim(ax, 'auto');
        end
    end
end
