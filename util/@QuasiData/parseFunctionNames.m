

function p = parseFunctionNames(p)
    
    % A or B
    validNames = {'A', 'B'};

    % Required names
    addRequired(p, 'fcnName', @(x) any(strcmp(x, validNames)));



end