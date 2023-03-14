function fig = ColouredStreamslice(X, Y, Z, U, V, W, xpos, ypos, zpos, varargin)
    % COLOUREDSTREAMSLICE(X, Y, Z, U, V, W, xpos, ypos, zpos)
    %
    % ColouredStreamslice generates coloured streamslice for a 3D plane at the requested x/y/z coordinates.
    %
    


    p = inputParser;

    p.addRequired('X');
    p.addRequired('Y');
    p.addRequired('Z');
    p.addRequired('U');
    p.addRequired('V');
    p.addRequired('W');

    p.addRequired('xpos');
    p.addRequired('ypos');
    p.addRequired('zpos');

    % TO DO: Validation and default functions
    ColourModeDefault = 'none';
    ColourModeValidation = {};
    p.addOptional('ColourMode', ColourModeDefault);

    p.addOptional('Alpha', 1);

    % TO DO: Validation and default functions
    ColourDataDefault = 'abs';
    ColourModeValidation = {};
    p.addOptional('ColourData', ColourDataDefault);

    % TO DO: Validation and default functions
    TarFigure = [];
    p.addOptional('Figure', TarFigure);


    parse(p, X, Y, Z, U, V, W, xpos, ypos, zpos, varargin{:});

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                           INITIALISE                              %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % TO DO: Deal with incorrect data types

    % TO DO: Add density
    density = 1;

    % TO DO: Add arrows
    arrows = 1;

    % TO DO: Add alpha
    A = 1;    

    % TO DO: Investigate methods
    method = 'linear';

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                           MAIN METHOD                             %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


     % TO DO: Correctly deal with axes
    if isempty(p.Results.Figure)
        fig = figure('Name', 'Coloured Streamslice');
        ax = axes('Parent', fig);
    else
        fig = p.Results.Figure;
        ax = gca;
    end

    

%     SET COLOURMAP
    factor = -10;
    
    M = colormap('turbo');

    mx = linspace(0, 1, 1024);
    I = (exp(factor*mx) - exp(factor*mx(1)));
    I = I/I(end);

    [r, ~] = size(M);
    mx = linspace(0, 1, r);
    
    E(:, 1) = interp1(mx, M(:, 1), I);
    E(:, 2) = interp1(mx, M(:, 2), I);
    E(:, 3) = interp1(mx, M(:, 3), I);
    

    colormap(E);

    


    switch p.Results.ColourMode
        case 'none'
            zidx = closestelement(Z(1, 1, :), zpos);
            X = X(:, :, zidx);
            Y = Y(:, :, zidx);
            U = U(:, :, zidx);
            V = V(:, :, zidx);
            BlackLines;
        case 'pcolor'
            zidx = closestelement(Z(1, 1, :), zpos);
            X = X(:, :, zidx);
            Y = Y(:, :, zidx);
            U = U(:, :, zidx);
            V = V(:, :, zidx);
            Pcolour;
            BlackLines;
        case 'surf'
            ColouredLines;
    end

    axis tight
    PlotDefaults.applyDefaultLabels;
    PlotDefaults.applyEqualAxes('xy');
    PlotDefaults.applySizes('std');



    function ColouredLines

        Uabs = sqrt(U.^2 + V.^2 + W.^2);
    
        Umax = max(max(max(Uabs)));
    
        U = U./Umax;
        V = V./Umax;
        W = W./Umax;
        fig_to_delete = figure;
        hf = streamslice(X, Y, Z, U, V, W, xpos, ypos, zpos);
    
        
    
        % Generate primary figure    
        for i = 1:length(hf)
            

    
            Lx = [hf(i).XData; hf(i).XData];
            Ly = [hf(i).YData; hf(i).YData];
            Lz = [hf(i).ZData; hf(i).ZData];
    
    
            U = interp3(X, Y, Z, Uabs, Lx, Ly, Lz);
            C = U;  % This is the color, vary with x in this case.

    
                surface(ax, Lx, Ly, Lz,C,...
                    'facecol','no',...
                    'edgecol','interp',...
                    'linew',2)

%                 alpha(p.Results.Alpha);
    
%                 if ~isempty(A)
%                     alpha(A)
%                 end
%     
            
        
            hold on
        end
        
        colorbar
    
        delete(fig_to_delete);

    end

    function BlackLines

        hf = streamslice(X, Y, U, V);

        % Change streamline colours
        
        for i = 1:length(hf)
            hf(i).Color = PlotDefaults.colours.blue(1, :);
            hf(i).LineWidth = 1.3;
            hf(i).HandleVisibility = 'off';
        end

    end

    function Pcolour
        Uabs = abs(U) + abs(V);
        pcolor(X, Y, Uabs./max(max(Uabs)));
        colorbar
        
        shading interp
        

    end

    



end