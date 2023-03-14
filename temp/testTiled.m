% Start a tiled layout



% for i = 1:4; QMO_Struct{i}.graphCoefficients; end

% Fetch all figures
F = groot().Children;
N = length(F);

% factor = -10;
% colormap turbo;
% M = colormap;
% 
% mx = linspace(0, 1, 1024);
% I = (exp(factor*mx) - exp(factor*mx(1)));
% I = I/I(end);
% 
% mx = linspace(0, 1, 256);
% E(:, 1) = interp1(mx', M(:, 1), I');
% E(:, 2) = interp1(mx', M(:, 2), I');
% E(:, 3) = interp1(mx', M(:, 3), I');
% 
% 
fig = figure;
t = tiledlayout('flow');

for i = length(F):-1:1

    ax = nexttile;
    targetAx = findobj(F(i), 'type', 'Axes');
    

    copyobj(targetAx.Children, ax);
    axis tight
    ax = gca;
    ax.XTick = [];
    ax.YTick = [];
    PlotDefaults.applyEqualAxes('xy');


    

    


    
    
end
colormap(E);
t.TileSpacing = 'tight';

%     curFigChildren = get(F(i), 'children');
%     
% 
%     copyobj()
% 
%     
%     set(gca,'ActivePositionProperty','outerposition')
%     set(gca,'Units','normalized')
%     set(gca,'OuterPosition',[0 0 1 1])
% 
% 
%     
% 
%     copyobj(F(i).Children.Children, fig.CurrentAxes)
% GUI_fig_children=get(gcf,'children');
% Fig_Axes=findobj(GUI_fig_children,'type','Axes');
% fig=figure;
% ax=axes;clf;
% new_handle=copyobj(Fig_Axes,fig);
