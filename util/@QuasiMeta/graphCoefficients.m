function fig = graphCoefficients(this, order)
            % GRAPHCOEFFICIENTS(this, order)
            %
            % Graph changes in coefficients over POIval. Coefficients are factorised into dimensions of velocity.

            % Local variable
            a = this.QuasiDataObj.VelData.colloidRadius;

            % Initialise coefficients and factor
            C = zeros(1, this.N);

            if nargin < 2
                orderList = 1:length(this.Coefficients{1});
            else
                orderList = order;
            end

            
            

            fig = figure('Name', 'Analytic Coefficients');
            colormap spring

            for i = 1:length(orderList)
                order = orderList(i);

                % Special case: Deal with order 0:
                if order == length(this.Coefficients{1})
                    DispStr = ['Order 0'];
                else
                    DispStr = ['Order ', num2str(order)];
                end

                % TO DO: Re-write order of coefficients, or make special case for correct factor for B0
                factor = a^(order - 1)/this.QuasiDataObj.colloidVelocity;
    
                % Fetch coefficients
                for j = 1:length(C)
                    C(j) = this.Coefficients{j}(order)/factor;
                end
                
                % TO DO: Re-write: Shift all coefficients up by one, so B0 becomes order 1 (numerically)
                
                plot(this.POIval, C, 'DisplayName', DispStr, 'LineWidth', PlotDefaults.std.LineWidth);
                hold on;               
            end

            hold off;

            % PLOTDEFAULTS: Must be added to path
            xlabel(this.POI, 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
            ylabel('Approximation Coefficients', 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
            legend('FontSize', PlotDefaults.std.FontSizeLeg);
            PlotDefaults.applySizes('std')
            PlotDefaults.setLatexDefault;
            grid on;

        end