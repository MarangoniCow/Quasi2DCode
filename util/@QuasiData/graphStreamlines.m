





function graphStreamlines(this, fcnName)


    switch(fcnName)
        case 'near'
            [Ur, Ut] = this.nearVelocityField;
        case 'far'
            [Ur, Ut] = this.farVelocityField;
    end

    % Generate a new figure
    fig = figure;


    % Check for defiend parameters
    this.checkForParameters;
    
    % Fetch coordinates
    X = this.VelData.X;
    Y = this.VelData.Y;
    
    % Colourmap plot: absolute value of velocity.    
    hold on
    Uabs = abs(Ur) + abs(Ut);
    pcolor(X, Y, Uabs);
    colormap parula
    shading interp

    hf = streamslice(X', Y', Ur', Ut');

    % Change streamline colours
    
    for i = 1:length(hf)
        hf(i).Color =  PlotDefaults.colours.blue(1, :);
        hf(i).LineWidth = 1.3;
    end
    hold off
    
    PlotDefaults.applyDefaultLabels;
    PlotDefaults.applyEqualAxis;
    PlotDefaults.applySizes('std');

end