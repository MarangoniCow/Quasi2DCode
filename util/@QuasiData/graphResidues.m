

function graphResidues(this, fcnName)


    % Check for defined parameters
    this.checkForParameters(fcnName);

    % Fetch the correct velocity field
    switch(fcnName)
        case 'B'
            [Ur, Ut] = this.velocityFieldB;
        case 'A'
            [Ur, Ut] = this.velocityFieldA;
    end

    % Generate a new figure
    fig = figure;

    % Fetch angular and radial coordinates
    Th = this.VelData.Th;
    R = this.VelData.R;

    % Fetch cartesian coordinates
    X = this.VelData.X;
    Y = this.VelData.Y;


    
    
    % Fetch simulation velocity
    Vx = this.VelData.velocityPlaneCartesian(:, :, 1);
    Vy = this.VelData.velocityPlaneCartesian(:, :, 2);

    % Convert approximation velocity
    Ux =    Ur.*cos(Th) - Ut.*sin(Th);
    Uy =    Ur.*sin(Th) + Ut.*cos(Th);

    % Normalise
    Ux = Ux./max(Ux);
    Uy = Uy./max(Uy);
    Vx = Vx./max(Vx);
    Vy = Vy./max(Vy);

    % Find difference 
    Wx = Vx - Ux;
    Wy = Vy - Uy;
    
    % Colourmap plot: absolute value of velocity.    
    hold on
    Uabs = abs(Wx) + abs(Wy);
    pcolor(X, Y, Uabs./max(Uabs));
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

    title(['Streamline residues for ', fcnName, 'approximation, ID: ' this.VelData.seriesID], 'interpreter', 'none')

end