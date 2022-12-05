

function fig = graphStreamfunction(this, fcnName)
    

    % Fetch streamfunction
    switch(fcnName)
        case 'near'
            psi = this.nearStreamfunction(this.VelData.R, this.VelData.Th);
        case 'far'
            psi = this.farStreamfunction(this.VelData.R, this.VelData.Th);
    end


    % Plot streamfunction surface
    fig = figure;
    surf(psi);


    % Set square x-y
    PlotDefaults.applyEqualAxis;
    PlotDefaults.applyDefaultLabels;
end