% Start a tiled layout



for i = 1:4; QMO_Struct{i}.graphCoefficients; end

% Fetch all figures
F = groot().Children;
N = length(F);

fig = figure;
t = tiledlayout('Flow'); 

for i = length(F):-1:1

    ax = nexttile;
    targetAx = findobj(F(i), 'type', 'Axes');

    copyobj(targetAx.Children, ax);


    


    
    
end

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
