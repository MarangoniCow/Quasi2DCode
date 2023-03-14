

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
    fig = figure('Name', 'Simulation/Analytic Residues');

    % Fetch angular and radial coordinates
    Th = this.VelData.Th;
    R = this.VelData.R;

    % Fetch cartesian coordinates
    X = this.VelData.X;
    Y = this.VelData.Y;


    % Fetch simulation velocity
    Vx = this.VelData.velocityPlaneCartesian(:, :, 1);
    Vy = this.VelData.velocityPlaneCartesian(:, :, 2);
    V  = sqrt(Vx.^2 + Vy.^2);

    % Convert approximation velocity
    Ux =    Ur.*cos(Th) - Ut.*sin(Th);
    Uy =    Ur.*sin(Th) + Ut.*cos(Th);
    

    % Find difference 
    Wx = Vx - Ux;
    Wy = Vy - Uy;
    
    % Colourmap plot: absolute value of velocity.    
    hold on
    Wabs = sqrt(Wx.^2 + Wy.^2)./max(V);
    pcolor(X, Y, Wabs./max(max(Wabs)));
    colorbar
    shading interp

    % SET COLOURMAP
    factor = -3;
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

    title(['Approximation Residues (', fcnName, '): ' this.VelData.seriesID], 'interpreter', 'none')

end