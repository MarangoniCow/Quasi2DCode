function fig = graphFminsum(this)
            % GRAPHFMINSUM(this)
            %
            % Graph Fminsum over POIval

            fig = figure('Name', 'Analytic Fminsum');                       
            Vbar = this.QuasiDataObj.VelData.avgSimulationVelocity;

            plot(this.POIval, this.Fminsum./Vbar, 'LineWidth', PlotDefaults.std.LineWidth);

            % PLOTDEFAULTS: Must be added to path to work!
            xlabel(this.POI, 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
            ylabel('Fminsum', 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
            PlotDefaults.applySizes('std')
            PlotDefaults.setLatexDefault;
            grid on;
end