classdef EdgeDetection
    properties
        % Original image
        orig_image
        % Greyscale image
        grey_image
        % Image with detected edges
        edge_image
    end
    
    methods
        % Constructor to load and process an image
        function obj = EdgeDetection(image_path)
            % loading image with imread
            obj.orig_image = imread(image_path);
            if size(obj.orig_image, 3) == 3
                % Convert to greyscale
                obj.grey_image = rgb2gray(obj.orig_image);
            else
                obj.grey_image = obj.orig_image;
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
            % Convert Matrix to grey scale image
            obj.edge_image = uint8(255 * mat2gray(obj.edge_image));
        end
        
        % Prewitt edge detection
        function obj = prewittEdgeDetection(obj)
            % Prewitt Kernels
            Gx = [-1 0 1; -1 0 1; -1 0 1];
            Gy = [-1 -1 -1; 0 0 0; 1 1 1];
            
            % Apply convolution
            gradX = conv2(double(obj.grey_image), Gx, 'same');
            gradY = conv2(double(obj.grey_image), Gy, 'same');
            
            % Gradient magnitude
            obj.edge_image = sqrt(gradX.^2 + gradY.^2);
            obj.edge_image = uint8(255 * mat2gray(obj.edge_image)); % Normalize
        end
        
        % Laplacian edge detection
        function obj = laplacianEdgeDetection(obj)
            % Laplacian Kernel (for second-order derivative)
            lap_ker = [0 -1 0; -1 4 -1; 0 -1 0];
            
            % Apply convolution
            edge_resp = conv2(double(obj.grey_image), lap_ker, 'same');
            
            % Absolute value to get edge strength
            obj.edge_image = abs(edge_resp);
            obj.edge_image = uint8(255 * mat2gray(obj.edge_image)); % Normalize
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