% some basics of plotting in 3D
function [] = plot3D()

    %% basic 3D plot
    % two sets of coordinates
    x = 0:pi/200:pi;
    x1 = sin(x).*cos(10*x);
    y1 = sin(x).*sin(10*x);
    z1 = cos(x);
    x2 = sin(x).*cos(12*x);
    y2 = sin(x).*sin(12*x);
    z2 = cos(x);
    % use plot3 similarly to plot in 2D
    plot3(x1,y1,z1,x2,y2,z2)
    title('Plot of 3D coordinates')

    %% plot of x^y on [0, 1] x [0, 1]
    % declare x and y on [0, 1] with step 0.01
    x = 0:0.01:1;
    y = 0:0.01:1;

    % create matrix Z to be filled with values of x^y
    n = size(x, 2);
    Z = zeros(n, n);

    % fill Z with values of x^y
    for i = 1:n
        for j = 1:n
            Z(i, j) = x(i)^y(j);
        end
    end

    % surface plotting
    figure;
    surf(x, y, Z);
    title('Surface of of x^y');

    % contour plotting
    figure;
    contour(x, y, Z);
    title('Contours of x^y');

    %% other example using linspace 
    % linspace(x, y) creates 100 equally distanced values in range [x, y]
    x = linspace(-2*pi, 2*pi);
    y = linspace(0, 4*pi);

    % 2D mesgrid - uniformly spaced grid - based on values stored in x, y
    % use breakpoints and try inspecting values of X and Y 
    [X, Y] = meshgrid(x, y);
    % some function
    Z = sin(X) + cos(Y);

    figure;
    contour(X,Y,Z)
    title('Contours of sin(X) + cos(Y)');

    figure;
    % face color set to none to create a net
    surf(X, Y, Z, 'FaceColor','none');
    title('Surface net of sin(X) + cos(Y)');

    %% another example with shading
    x = -2:0.25:2;
    [X, Y] = meshgrid(x);
    Z = X .* exp(-X.^2 - Y.^2);
    figure;
    % surface with colormap shading
    surfl(X,Y,Z)
    colormap("pink");
    shading interp;
    title('Surface with shading');
end