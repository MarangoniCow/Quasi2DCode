%%%%% GRAPHVELOCITYPLANE %%%%%
%
% Acts on a VelocityPlane object to graph the velocity plane.


function fig = graph3DVelocity(this)

    % Generate a new figure
    fig = figure;

    t = this.timeStep;

    x0 = this.colloidDisp(1, t);
    y0 = this.colloidDisp(2, t);
    z0 = this.colloidDisp(3, t);

    a = this.colloid_a;

    
    % Fetch coordinates
    x = this.X(:, 1);
    y = this.Y(1, :);
    z = this.Z(1, :);
    [Y, Z] = meshgrid(y, z);
    Y = Y';
    Z = Z';
    

    xidx = floor(x0 - 6*a):3*floor(a):floor(x0 + 6*a);
   



    




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