function fig = ColouredStreamslice(X, Y, Z, U, V, W, xpos, ypos, zpos, ax, A)


    Uabs = sqrt(U.^2 + V.^2 + W.^2);
    
    Umax = max(max(max(Uabs)));

    U = U./Umax;
    V = V./Umax;
    W = W./Umax;
    fig_to_delete = figure;
    hf = MyStreamslice(X, Y, Z, U, V, W, xpos, ypos, zpos);

    
    if isempty(fighandle)
        fig = figure;
    else
        fig = fighandle;
    end

    % Generate primary figure
    
    


    

    
    
    for i = 1:length(hf)
        
        
        
    

        Lx = [hf(i).XData; hf(i).XData];
        Ly = [hf(i).YData; hf(i).YData];
        Lz = [hf(i).ZData; hf(i).ZData];


        U = interp3(X, Y, Z, Uabs, Lx, Ly, Lz);
        C = log(U);  % This is the color, vary with x in this case.

        

        

        

            surface(ax, Lx, Ly, Lz,C,...
                'facecol','no',...
                'edgecol','interp',...
                'linew',2);

            if ~isempty(A)
                alpha(A)
            end

        
    
        
    
        hold on
    end
    colormap turbo
    colorbar

    delete(fig_to_delete);



    
    





end