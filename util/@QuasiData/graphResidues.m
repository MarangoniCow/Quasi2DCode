

function graphResidues(this, fcnName)


    switch(fcnName)
        case 'near'
            [Ur, Ut] = this.nearVelocityField;
        case 'far'
            [Ur, Ut] = this.farVelocityField;
    end

    % Generate a new figure
    fig = figure;

    Th = this.VelData.Th;
    R = this.VelData.R;


    % Check for defiend parameters
    this.checkForParameters;
    
    % Fetch coordinates
    X = this.VelData.X;
    Y = this.VelData.Y;
    Vx = this.VelData.velocityPlanePolar(:, :, 1);
    Vy = this.VelData.velocityPlanePolar(:, :, 2);

    Ux =    Ur.*cos(Th) - Ut.*sin(Th);
    Uy =    Ur.*sin(Th) + Ut.*cos(Th);

    Ux = Ux./max(Ux);
    Uy = Uy./max(Uy);

    Vx = Vx./max(Vx);
    Vy = Vy./max(Vy);

    


    Wx = Vx - Ux;
    Wy = Vy - Uy;
    
    
    % Colourmap plot: absolute value of velocity.    
    hold on
    Uabs = abs(Wx) + abs(Wy);
    pcolor(X, Y, Uabs);
    colormap parula
    shading interp

    hf = streamslice(X', Y', Wx', Wy');

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

    title(['Streamline residues for ', fcnName, 'field, ID: ' this.VelData.seriesID], 'interpreter', 'none')

end