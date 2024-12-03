% Image filtering app, which will remind us somewhat of the edge detection
% we did in classes seven and eight. Callback function applyFilter not yet
% added and will be done during the next class.

function imageFilter
    % Clear workspace and close figures
    clear; clc; close all;

    % Create the main window
    fig = figure('Name', 'Image Filtering App', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 1000, 600], ...
                 'Resize', 'off');

    % Axes for original and filtered images
    ax1 = axes('Parent', fig, ...
               'Position', [0.05, 0.25, 0.4, 0.7], ...
               'Box', 'on');
    title(ax1, 'Original Image');
    ax2 = axes('Parent', fig, ...
               'Position', [0.55, 0.25, 0.4, 0.7], ...
               'Box', 'on');
    title(ax2, 'Filtered Image');

    % Control Panel
    uicontrol('Style', 'text', 'String', 'Filter Type:', ...
              'Position', [50, 120, 100, 20], ...
              'HorizontalAlignment', 'left', 'FontSize', 10);
    filter_dropdown = uicontrol('Style', 'popupmenu', ...
                                'String', {'None', 'Gaussian Blur', 'Edge Detection', 'Sharpen', 'Emboss'}, ...
                                'Position', [150, 120, 150, 20], ...
                                'Callback', @applyFilter);
    
    % Parameter Sliders
    uicontrol('Style', 'text', 'String', 'Parameter 1:', ...
              'Position', [50, 80, 100, 20], ...
              'HorizontalAlignment', 'left', 'FontSize', 10);
    param1_slider = uicontrol('Style', 'slider', ...
                              'Min', 0, 'Max', 10, 'Value', 1, ...
                              'Position', [150, 80, 150, 20], ...
                              'Callback', @applyFilter);

    uicontrol('Style', 'text', 'String', 'Parameter 2:', ...
              'Position', [50, 40, 100, 20], ...
              'HorizontalAlignment', 'left', 'FontSize', 10);
    param2_slider = uicontrol('Style', 'slider', ...
                              'Min', 0, 'Max', 10, 'Value', 1, ...
                              'Position', [150, 40, 150, 20], ...
                              'Callback', @applyFilter);

    % Load and Save Buttons
    load_btn = uicontrol('Style', 'pushbutton', 'String', 'Load Image', ...
                         'Position', [400, 100, 100, 30], ...
                         'Callback', @loadImage);
    save_btn = uicontrol('Style', 'pushbutton', 'String', 'Save Image', ...
                         'Position', [520, 100, 100, 30], ...
                         'Callback', @saveImage);

    % Internal data
    img = [];
    filtered_img = [];

    % Load Image Function
    function loadImage(~, ~)
        [file, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'});
        if isequal(file, 0)
            return;
        end

        img = imread(fullfile(path, file));
        axes(ax1);
        imshow(img, []);
        title(ax1, 'Original Image');
        axes(ax2);
        imshow(img, []);
        title(ax2, 'Filtered Image');
        filtered_img = img;
    end

    % Save Image Function
    function saveImage(~, ~)
        if isempty(filtered_img)
            errordlg('No filtered image to save.', 'Error');
            return;
        end

        % in this case, the file extensions below must be written with
        % single quotation marks for them to be character arrays rather
        % than a string
        [file, path] = uiputfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'}, 'Save Image As');
        if isequal(file, 0)
            return;
        end
        imwrite(filtered_img, fullfile(path, file));
        msgbox('Image saved successfully!', 'Success');
    end
end
