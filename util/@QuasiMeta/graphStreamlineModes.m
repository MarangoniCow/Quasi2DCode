function fig = graphStreamlineModes(this, POIvalIDX, order)
    % GRAPHSTREAMLINEMODES(this, POIvalIDX, order)
    %
    % Graph the streamline modes individually
    
    % Check validity of order
    order = int16(order);
    validateattributes(order, {'int16'}, {'positive'})
    
    % Fetch coefficients
    M = length(this.Coefficients{1});
    Coeff = this.Coefficients{POIvalIDX}(:);
    Coeff(1:M ~= order) = 0;
    
    
    % Assign coefficients to QuasiDataObj
    CoeffStr = ['Coeff', this.ApproxType];
    this.QuasiDataObj.(CoeffStr) = Coeff;
    
    % Temporarily set colloidVelocity to zero
    colloidVelocity = this.QuasiDataObj.colloidVelocity;
    this.QuasiDataObj.colloidVelocity = 0;
    
    % Graph streamlines
    fig = this.QuasiDataObj.graphStreamlines(this.ApproxType);
    
    % Return colloidVelocity to original value
    this.QuasiDataObj.colloidVelocity = colloidVelocity;


            


end