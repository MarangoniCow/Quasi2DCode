

function fig = graphStreamfunction(this, fcnName)
    

    % Fetch streamfunction
    switch(fcnName)
        case 'B'
            psi = this.streamFunction_B(this.VelData.R, this.VelData.Th);
        case 'A'
            psi = this.streamFunction_A(this.VelData.R, this.VelData.Th);
    end


    % Plot streamfunction surface
    fig = figure('Name', 'Analytic Streamfunction');
    surf(psi);


    % Set square x-y
    PlotDefaults.applyEqualAxes('xy');
    PlotDefaults.applyDefaultLabels;
end