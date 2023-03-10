ux = hf(1).XData;
uy = hf(1).YData;
uz = hf(1).ZData;

U = sqrt(ux.^2 + uy.^2 + uz.^2);
col = U;  % This is the color, vary with x in this case.
surface([ux;ux],[uy;uy],[uz;uz],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);