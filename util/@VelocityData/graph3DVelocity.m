%%%%% GRAPHVELOCITYPLANE %%%%%
%
% Acts on a VelocityPlane object to graph the velocity plane.


function fig = graph3DVelocity(this)

    % Generate a new figure
    fig = figure('Name', 'Simulation 3D Velocity')

    % Fetch local variables
    t = this.timeStep;
    a = this.colloid_a;

    x0 = this.colloidDisp(1, t);
    y0 = this.colloidDisp(2, t);
    z0 = this.colloidDisp(3, t);
   
    % Fetch coordinates
    x = this.X(:, 1);
    y = this.Y(1, :);
    z = this.Z(1, :);
    [Y, Z] = meshgrid(y, z);

    % Generate sphere coordinates
    [xs, ys, zs] = sphere;
    xs = xs*a;
    ys = ys*a;
    zs = zs*a;

    % Plot colloid
    surf(xs, ys, zs, 'HandleVisibility', 'off', 'EdgeColor','none', 'FaceColor', 'interp');
    axis equal

    map = zeros(20, 3);
    for i = 1:20
        map(i, 3) = 0.25 + i*0.028;
    end
    colormap(map)
    


%     xidx = floor(x0 - 6*a):3*floor(a):floor(x0 + 6*a);
   
    % Colourmap plot: absolute value of velocity.    

    hold on
    for i = 1:5
        xPos = x(xidx(i));
        V = this.velocityYZPlane{i}(:, :, 1);
        W = this.velocityYZPlane{i}(:, :, 2);
        Uabs = abs(V) + abs(W);
        surf(xPos*ones(size(Y)), Y, Z, Uabs./max(Uabs), 'edgecolor', 'none', 'facealpha', 0.5)
        colormap parula
        shading interp
    end


    % Fetch coordinates
    X = this.X;
    Y = this.Y;
    U = this.velocityPlaneCartesian(:, :, 1);
    V = this.velocityPlaneCartesian(:, :, 2);


    % Colourmap plot: absolute value of velocity.    
    hold on
    Uabs = abs(U) + abs(V);
    Uabs = Uabs./max(Uabs);
    surf(X, Y, z0*ones(size(X)), Uabs./max(Uabs), 'facealpha', 0.5)
    colormap parula
    shading interp

    

    hold off
    
    % Apply plot defaults
    axis tight
    PlotDefaults.applyDefaultLabels;
    PlotDefaults.applyEqualAxes('xy');
    PlotDefaults.applySizes('std');
    title(['Streamlines for series ID: ' this.seriesID], 'interpreter', 'none')

end