function imageFilter
    clear; clc; close all;

    % Create main window
    fig = figure('Name', 'Image Filter Playground', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 1200, 800], ...
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
              'Position', [500, 130, 100, 20], ...
              'HorizontalAlignment', 'left', 'FontSize', 10);
    filter_dropdown = uicontrol('Style', 'popupmenu', ...
                                'String', {'None', 'Gaussian Blur', 'Edge Detection', 'Sharpen', 'Emboss'}, ...
                                'Position', [580, 130, 150, 20], ...
                                'Callback', @applyFilter);

    uicontrol('Style', 'text', 'String', 'Parameter 1:', ...
              'Position', [500, 100, 100, 20], ...
              'HorizontalAlignment', 'left', 'FontSize', 10);
    param1_slider = uicontrol('Style', 'slider', ...
                              'Min', 0, 'Max', 10, 'Value', 1, ...
                              'Position', [580, 100, 150, 20], ...
                              'Callback', @applyFilter);

    uicontrol('Style', 'text', 'String', 'Parameter 2:', ...
              'Position', [500, 70, 100, 20], ...
              'HorizontalAlignment', 'left', 'FontSize', 10);
    param2_slider = uicontrol('Style', 'slider', ...
                              'Min', 0, 'Max', 10, 'Value', 1, ...
                              'Position', [580, 70, 150, 20], ...
                              'Callback', @applyFilter);

    load_btn = uicontrol('Style', 'pushbutton', 'String', 'Load Image', ...
                         'Position', [520, 30, 100, 30], ...
                         'Callback', @loadImage);
    save_btn = uicontrol('Style', 'pushbutton', 'String', 'Save Image', ...
                         'Position', [620, 30, 100, 30], ...
                         'Callback', @saveImage);

    % Internal data
    img = [];
    filtered_img = [];

    % Load Image Function
    % Callback function need to have two input parameters - a source, e.g. a button,
    % and an event, e.g. a pressdown
    % the function general signature is therefore callback(src, event)
    % In this case, we need neither of those as there is only one possible
    % source and one possible event, which may trigger this callback
    function loadImage(~, ~)
        [file, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'});
        % If user cancels
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

        [file, path] = uiputfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'}, 'Save Image As');
        if isequal(file, 0)
            return;
        end

        imwrite(filtered_img, fullfile(path, file));
        msgbox('Image saved successfully!', 'Success');
    end

    % Apply Filter Function
    function applyFilter(~, ~)
        if isempty(img)
            errordlg('Please load an image first.', 'Error');
            return;
        end
    
        % Get filter type and parameters
        filter_type = filter_dropdown.String{filter_dropdown.Value};

        % Slider values for Parameter 1, 2
        param1 = param1_slider.Value;
        param2 = param2_slider.Value;
    
        switch filter_type
            case 'None'
                filtered_img = img;
            case 'Gaussian Blur'
                % fspecial is a 2D filter of input type
                h = fspecial('gaussian', [5 5], param1);
                filtered_img = imfilter(img, h);
            case 'Edge Detection'
                % Normalize slider values to [0, 1] range for edge function
                thresh1 = min(param1, param2) / 10;
                thresh2 = max(param1, param2) / 10;

                filtered_img = edge(rgb2gray(img), 'Canny', [thresh1, thresh2]);

                % Convert binary edge output to RGB for display
                filtered_img = repmat(uint8(filtered_img) * 255, [1 1 3]);
            case 'Sharpen'
                % Normalize param1 to the valid range (0, 1]
                alpha = max(0.01, min(1, param1 / 10));
                h = fspecial('unsharp', alpha);
                filtered_img = imfilter(img, h);
            case 'Emboss'
                h = [ -2 -1 0; -1  1 1;  0  1 2] * param1;
                filtered_img = imfilter(img, h) + 128;
            otherwise
                filtered_img = img;
        end
    
        % Update the filtered image display
        axes(ax2);
        imshow(filtered_img, []);
        title(ax2, 'Filtered Image');
    end
end
