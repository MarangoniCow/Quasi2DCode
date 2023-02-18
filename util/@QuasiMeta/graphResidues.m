 function fig = graphResidues(this, idx)
    % GRAPHRESIDUES(this, idx)
    %
    % Graph streamline residues 
    this.assignCoefficients(QuasiObj, idx);
    fig = QuasiObj.graphResidues(this.ApproxType);
end