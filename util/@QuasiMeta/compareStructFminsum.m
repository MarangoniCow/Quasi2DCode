function fig = compareStructFminsum(QMO_Struct, dispStr, dispStrVal)
% COMPARESTRUCTFMINSUM
%
% Compare Fminsum over multiple struct values


    fig = figure;

    for i = 1:length(QMO_Struct)
        QMO = QMO_Struct{i};
        Vbar = QMO.QuasiDataObj.VelData.avgSimulationVelocity;
    
        plot(QMO.POIval, QMO.Fminsum./Vbar, 'LineWidth', PlotDefaults.std.LineWidth);
        hold on
    end
    hold off
    
    % PLOTDEFAULTS: Must be added to path to work!
    xlabel(QMO.POI, 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
    ylabel('Fminsum', 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
    PlotDefaults.applySizes('std')
    PlotDefaults.setLatexDefault;
    grid on;





end