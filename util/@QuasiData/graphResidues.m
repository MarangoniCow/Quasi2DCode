

function graphResidues(this)


    % Check for defined parameters
    this.checkForParameters;
    
    % Fetch field
    [Ux, Uy] = this.quasi2DVelocity(this.Coeff, this.VelData.R, this.VelData.Th, true);

    %  Set velocity to zero where the colloid is
    Vr = this.VelData.velocityPlanePolar(:, :, 1);
    
    % Find colloid location
    idxlist = find(~Vr);
    Ux(idxlist) = 0;
    Uy(idxlist) = 0;
    U = norm([Ux; Uy]);

    % Generate a new figure
    fig = figure('Name', 'Simulation/Analytic Residues');

    % Fetch cartesian coordinates
    X = this.VelData.X;
    Y = this.VelData.Y;


    % Fetch simulation velocity
    Vx = this.VelData.velocityPlaneCartesian(:, :, 1);
    Vy = this.VelData.velocityPlaneCartesian(:, :, 2);
    Vabs = sqrt(Vx.^2 + Vy.^2);
    

    % Find difference 
    Wx = Vx - Ux;
    Wy = Vy - Uy;

    Wabs = sqrt(Wx.^2 + Wy.^2);
    C = Wabs./Vabs;

    
    
    
    % Colourmap plot: absolute value of velocity.    
    hold on
    pcolor(X, Y, C);
    colorbar
    shading interp

    % SET COLOURMAP
    factor = -1;
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
    clim([0 1])


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

    title(['Approximation Residues: ' this.VelData.seriesID], 'interpreter', 'none')

end