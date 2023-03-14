





function fig = graphStreamlines(this, fcnName)


    switch(fcnName)
        case 'B'
            [Ur, Ut] = this.velocityFieldB;
        case 'A'
            [Ur, Ut] = this.velocityFieldA;
    end

    % Generate a new figure
    fig = figure('Name', 'Analytic Streamlines');


    % Check for defiend parameters
    this.checkForParameters(fcnName);
    
    % Fetch coordinates
    X = this.VelData.X;
    Y = this.VelData.Y;
    
    % Colourmap plot: absolute value of velocity.    
    hold on
    Uabs = abs(Ur) + abs(Ut);
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
    title(['Approximation Streamlines (', fcnName, '): ' this.VelData.seriesID], 'interpreter', 'none')

end