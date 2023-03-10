function fig = compareStructCoefficients(QMO_Struct, order, dispStr, dispStrVal)
    % COMPARESTRUCTCOEFFICIENTS
    %
    % Compare coefficients over a from a QuasiMeta Struct

    
    % Input checks
    if length(QMO_Struct) ~= length(dispStrVal)
        error('Discrepency between QMO_Struct and legend display values');
    end
    
    % Set-up variables
    n = length(QMO_Struct);

    fig = figure('Name', 'Compare Approximation Coefficients');
    coeffFig = QMO_Struct{1}.graphCoefficients(order);
    [figLegend, figLines] = coeffFig.Children.Children;
    delete(figLegend);
    delete(figLines);
    copyobj(coeffFig.Children, fig);
    delete(coeffFig);
    ax = gca;
    
    for i = 1:n
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
    

    m = length(dispStrVal);

    if m ~= n
        warning('Discrepancy between QuasiMetaStruct and display string values')
    end


    L = cell(1, n);
    for i = 1:n
        L{i} = [dispStr, num2str(dispStrVal(i))];
    end

    legend(L)


end