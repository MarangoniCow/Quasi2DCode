

function p = parseFunctionNames(p)
    
    % Near or far
    validNames = {'near', 'far'};

    % Required names
    addRequired(p, 'fcnName', @(x) any(strcmp(x, validNames)));



end