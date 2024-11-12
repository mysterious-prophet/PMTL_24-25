classdef EdgeDetection
    properties
        orig_image     % Original image loaded
        grey_image         % Grayscale version of the image
        edge_image         % Image with detected edges
    end
    
    methods
        % Constructor to load and process an image
        function obj = EdgeDetection(image_path)
            obj.orig_image = imread(image_path); % Load the image
            if size(obj.orig_image, 3) == 3
                obj.grey_image = rgb2gray(obj.orig_image); % Convert to grayscale
            else
                obj.grey_image = obj.orig_image; % Image is already grayscale
            end
        end
        
        % Sobel edge detection without using edge()
        function obj = sobelEdgeDetection(obj)
            % Sobel Kernels
            Gx = [-1 0 1; -2 0 2; -1 0 1];
            Gy = [-1 -2 -1; 0 0 0; 1 2 1];
            
            % Apply convolution
            gradX = conv2(double(obj.grey_image), Gx, 'same');
            gradY = conv2(double(obj.grey_image), Gy, 'same');
            
            % Gradient magnitude
            obj.edge_image = sqrt(gradX.^2 + gradY.^2);
            % Convert Matrix to Gray scale image
            obj.edge_image = uint8(255 * mat2gray(obj.edge_image));
        end
        
        % Display original and edge-detected images
        function showResult(obj, title_text)
            figure;
            subplot(1, 2, 1);
            imshow(obj.orig_image);
            title('Original Image');
            
            subplot(1, 2, 2);
            imshow(obj.edge_image);
            title(title_text);
        end
    end
end