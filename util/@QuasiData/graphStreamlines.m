





function fig = graphStreamlines(this, fcnName)
    
    % Check for defined parameters
    this.checkForParameters;

    % Generate a new figure
    fig = figure('Name', 'Analytic Streamlines');

    [Ux, Uy] = this.quasi2DVelocity(this.Coeff, this.VelData.R, this.VelData.Th, true);

    X = this.VelData.X;
    Y = this.VelData.Y;
    

    
    
    %  Set velocity to zero where the colloid is
    Vr = this.VelData.velocityPlanePolar(:, :, 1);
    
    % Find colloid location
    idxlist = find(~Vr);
    Ux(idxlist) = 0;
    Uy(idxlist) = 0;
    Uabs = abs(Ux) + abs(Uy);

    % Pcolour
    hold on
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
    title(['Approximation Streamlines: ' this.VelData.seriesID], 'interpreter', 'none')

end