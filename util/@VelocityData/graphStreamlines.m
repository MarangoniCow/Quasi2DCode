%%%%% GRAPHVELOCITYPLANE %%%%%
%
% Acts on a VelocityPlane object to graph the velocity plane.


function fig = graphStreamlines(this)

    % 

    % Generate a new figure
    fig = figure('Name', 'Simulation Streamlines');

    

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
    pcolor(X, Y, Uabs./max(max(Uabs)));
    colorbar
   
    shading interp
    % SET COLOURMAP
    factor = -10;
    colormap turbo;
    M = colormap;

    mx = linspace(0, 1, 1024);
    I = (exp(factor*mx) - exp(factor*mx(1)));
    I = I/I(end);
    
    mx = linspace(0, 1, 256);
    E(:, 1) = interp1(mx', M(:, 1), I');
    E(:, 2) = interp1(mx', M(:, 2), I');
    E(:, 3) = interp1(mx', M(:, 3), I');
    

    colormap(E);

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
    title(['Simulation streamlines: ' this.seriesID], 'interpreter', 'none')

end