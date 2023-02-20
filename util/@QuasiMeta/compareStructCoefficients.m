function fig = compareStructCoefficients(QMO_Struct, order, dispStr, dispStrVal)
    % COMPARESTRUCTCOEFFICIENTS
    %
    % Compare coefficients over a from a QuasiMeta Struct

    
    % Input checks
    if length(QMO_Struct) ~= length(dispStrVal)
        error('Discrepency between QMO_Struct and legend display values');
    end
    
    % Set-up variables
    N = length(QMO_Struct);

    fig = figure;
    coeffFig = QMO_Struct{1}.graphCoefficients(order);
    [figLegend, figLines] = coeffFig.Children.Children;
    delete(figLegend);
    delete(figLines);
    copyobj(coeffFig.Children, fig);
    delete(coeffFig);
    ax = gca;
    
    for i = 1:N
        % Fetch figure handle
        coeffFig = QMO_Struct{i}.graphCoefficients(order);

        % Fetch figure lines
        [~, figLines] = coeffFig.Children.Children;
        L = figLines(end);

        % Update display name and colour
        L.DisplayName = [dispStr, num2str(dispStrVal(i))];
        L.Color = PlotDefaults.fetchColourByIdx(i);
        copyobj(L, ax);
        delete(coeffFig);
    end
    

    


end