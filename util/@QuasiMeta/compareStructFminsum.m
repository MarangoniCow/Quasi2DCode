function fig = compareStructFminsum(QMO_Struct, dispStr, dispStrVal)
% COMPARESTRUCTFMINSUM
%
% Compare Fminsum over multiple struct values


    fig = figure('Name', 'Compare Approximation Fminsums');

    n = length(QMO_Struct);

    for i = 1:n
        QMO = QMO_Struct{i};
        Vbar = QMO.QuasiDataObj.VelData.avgSimulationVelocity;
    
        plot(QMO.POIval, QMO.Fminsum./Vbar, 'LineWidth', PlotDefaults.std.LineWidth, ...
            'Color', PlotDefaults.fetchColourByIdx(i));
        hold on
    end
    hold off
    
    % PLOTDEFAULTS: Must be added to path to work!
    xlabel(QMO.POI, 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
    ylabel('Fminsum', 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
    PlotDefaults.applySizes('std')
    PlotDefaults.setLatexDefault;
    grid on;

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