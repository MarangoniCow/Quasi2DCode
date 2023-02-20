 function fig = graphResidues(this, idx)
    % GRAPHRESIDUES(this, idx)
    %
    % Graph streamline residues 
    this.assignCoefficients(idx);
    this.QuasiDataObj.graphResidues(this.ApproxType);
end