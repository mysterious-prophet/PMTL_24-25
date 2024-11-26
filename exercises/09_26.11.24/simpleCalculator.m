% GUI apps are usually done with nested functions in MATLAB
% This is an example of a simple calculator app. It has the basics, but
% there are also many functions and operators missing as well as problems,
% e.g. the decimal dot, which can be inputted unlimited number of times. 
% Basic exception handling is also implemented in this example.
% You can try to improve upon this example yourselves by adding more 
% operators, parentheses, solving the problem with decimal dot...

function simpleCalculator
    % Clear workspace and close all figures
    clear; clc; close all;

    % Create the main calculator window with preset dimensions and centering based on screen dimensions 
    screen_size = get(0, 'ScreenSize');
    fig_width = 500;
    fig_height = 700;
    fig_center_hor = (screen_size(3) - fig_width) / 2;
    fig_center_vert = (screen_size(4) - fig_height) / 2;

    % create nonresizeable figure, with no menu bar
    h = figure('Position', [fig_center_hor, fig_center_vert, fig_width, fig_height], ...
               'Name', 'Simple Calculator', ...
               'NumberTitle', 'off', ...
               'MenuBar', 'none', ...
               'Resize', 'off', ...
               'CloseRequestFcn', @(src, event) delete(src));

    % Create the display for the calculator
    disp1 = uicontrol('Parent', h, ...
                      'Style', 'text', ...
                      'Units', 'pixels', ...
                      'Position', [25, fig_height - 150, fig_width - 50, 100], ...
                      'String', '', ...
                      'FontSize', 18, ...
                      'HorizontalAlignment', 'right', ...
                      'BackgroundColor', 'white', ...
                      'Tag', 'display');

    % Define button labels and and their tags
    button_labels = {'7', '8', '9', '+', 'C', ...
                    '4', '5', '6', '-', 'sqrt', ...
                    '1', '2', '3', '*', 'x^2', ...
                    '0', '.', '=', '/', '1/x'};
    button_tags = {'seven', 'eight', 'nine', 'plus', 'clear', ...
                  'four', 'five', 'six', 'minus', 'sqrt', ...
                  'one', 'two', 'three', 'multiply', 'square', ...
                  'zero', 'dot', 'equals', 'divide', 'inverse'};

    % Adjust button dimensions
    button_width = 80;
    button_height = 60;
    margin_hor = 15;
    margin_vert = 15;

    % starting position for buttons
    start_hor = 25;
    start_vert = fig_height - 250;

    % Create buttons in a grid layout
    rows = 5;
    cols = 5;
    for i = 1:rows
        for j = 1:cols
            idx = (i - 1) * cols + j; % Button index
            if idx > length(button_labels)
                continue; % Skip if button index exceeds label count
            end

            % Calculate button position
            x_pos = start_hor + (j - 1) * (button_width + margin_hor);
            y_pos = start_vert - (i - 1) * (button_height + margin_vert);

            % Create the push button with label and tag
            % Behaviour of each button is implemented with a callback
            % function
            uicontrol('Parent', h, ...
                      'Style', 'pushbutton', ...
                      'Units', 'pixels', ...
                      'Position', [x_pos, y_pos, button_width, button_height], ...
                      'String', button_labels{idx}, ...
                      'FontSize', 14, ...
                      'Tag', button_tags{idx}, ...
                      'Callback', @(src, ~) buttonCallback(src, disp1));
        end
    end

    % Callback function for button presses
    function buttonCallback(src, display)
        current_txt = display.String;
        button_txt = src.String;

        switch button_txt
            case 'C'
                % Clear the display
                display.String = '';

            case '='
                % Evaluate the expression
                try
                    result = eval(current_txt);
                    display.String = num2str(result);
                catch
                    display.String = 'Error';
                end

            case 'sqrt'
                % Calculate square root
                try
                    % it is necessary to convert the input string to
                    % numbers
                    result = sqrt(str2double(current_txt));
                    if isnan(result)
                        error('Invalid input for sqrt');
                    end
                    % and then convert back to string
                    display.String = num2str(result);
                catch
                    display.String = 'Error';
                end

            case 'x^2'
                % Square the current value
                try
                    result = str2double(current_txt)^2;
                    display.String = num2str(result);
                catch
                    display.String = 'Error';
                end

            case '1/x'
                % Calculate the reciprocal
                try
                    result = 1 / str2double(current_txt);
                    display.String = num2str(result);
                catch
                    display.String = 'Error';
                end

            otherwise
                % Append the button text to the current input
                display.String = strcat(current_txt, button_txt);
        end
    end
end
