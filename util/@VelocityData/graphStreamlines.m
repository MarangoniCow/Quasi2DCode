%%%%% GRAPHVELOCITYPLANE %%%%%
%
% Acts on a VelocityPlane object to graph the velocity plane.


function fig = graphStreamlines(this)

    % 

    % Generate a new figure
    fig = figure;

    

    % Check for plane existence
    this.checkForPolarPlane;
    
    % Fetch coordinates
    X = this.X;
    Y = this.Y;
    U = this.velocityPlaneCartesian(:, :, 1);
    V = this.velocityPlaneCartesian(:, :, 2);


    % Colourmap plot: absolute value of velocity.    
    hold on
    Uabs = abs(U) + abs(V);
    pcolor(X, Y, Uabs./max(Uabs));
    colorbar
    colormap parula
    shading interp

    hf = streamslice(X', Y', U', V');

    % Change streamline colours
    
    for i = 1:length(hf)
        hf(i).Color = PlotDefaults.colours.blue(1, :);
        hf(i).LineWidth = 1.3;
        hf(i).HandleVisibility = 'off';
    end


    hold off
    
    % Apply plot defaults
    axis tight
    PlotDefaults.applyDefaultLabels;
    PlotDefaults.applyEqualAxes('xy');
    PlotDefaults.applySizes('std');
    title(['Streamlines for series ID: ' this.seriesID], 'interpreter', 'none')

end