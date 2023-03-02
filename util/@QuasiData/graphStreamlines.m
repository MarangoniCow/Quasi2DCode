





function fig = graphStreamlines(this, fcnName)


    switch(fcnName)
        case 'B'
            [Ur, Ut] = this.velocityFieldB;
        case 'A'
            [Ur, Ut] = this.velocityFieldA;
    end

    % Generate a new figure
    fig = figure;


    % Check for defiend parameters
    this.checkForParameters(fcnName);
    
    % Fetch coordinates
    X = this.VelData.X;
    Y = this.VelData.Y;
    
    % Colourmap plot: absolute value of velocity.    
    hold on
    Uabs = abs(Ur) + abs(Ut);
    pcolor(X, Y, Uabs./max(Uabs));
    colorbar
    colormap parula
    shading interp

    R   = this.VelData.R;
    Th  = this.VelData.Th;

    Ux =    Ur.*cos(Th) - Ut.*sin(Th);
    Uy =    Ur.*sin(Th) + Ut.*cos(Th);

    hf = streamslice(X', Y', Ux', Uy');

    % Change streamline colours
    
    for i = 1:length(hf)
        hf(i).Color =  PlotDefaults.colours.blue(1, :);
        hf(i).LineWidth = 1.3;
    end
    hold off
    
    axis tight
    PlotDefaults.applyDefaultLabels;
    PlotDefaults.applyEqualAxes('xy');
    PlotDefaults.applySizes('std');
    title(['Streamlines for ', fcnName, 'field, ID: ' this.VelData.seriesID], 'interpreter', 'none')

end