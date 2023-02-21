function QMO_Struct = generateQuasiCoefficients(QuasiDataObj, varargin)
    % GENERATEQUASICOEFFICIENTS(QuasiDataObj)
    %
    % Generate a range of coefficients to be stored in a QuasiDataObj.


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                       PARSE INPUTS                            %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    p = inputParser;

    % QuasiData object
    p.addRequired('QuasiDataObj');

    % Local variables
    colloidRadius = QuasiDataObj.colloidRadius;

    % POIval (POI is always exclusion radius)
    exclusionDefault = 1:2:floor(4*colloidRadius);
    p.addOptional('exclusionRadius', exclusionDefault);

    % SOIval (SOI is always solve order)
    solveDefault = [2, 4, 6, 8];
    p.addOptional('solveOrder', solveDefault);

    % ApproximationType
    approxTypeDefault = 'B';
    p.addOptional('ApproxType', approxTypeDefault);

    % Parse inputs
    parse(p, 'QuasiDataObj', varargin{:});

    % Fetch results
    solveOrder      = p.Results.solveOrder;
    exclusionRadius = p.Results.exclusionRadius;
    
    % Warnings
    if any(strcmp('solveOrder', p.UsingDefaults))
        warning('Ensure requested solveOrder is in multiples of two!')
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                       MAIN METHOD                             %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    

    % Initialise structs
    QMO_Struct      = cell(1, length(solveOrder));
    ParDataOutput   = cell(1, length(exclusionRadius));
    CoeffGuess      = cell(1, length(solveOrder));

    % Generate default guesses exclusionRadius 
    for i = 1:length(exclusionRadius)
        CoeffGuess{i} = [1.2, 110, 0.1];
    end

    % Set-up solveOrder sweep
    for i = 1:length(solveOrder)

        % Initialise QuasiMetaObject
        QMO = QuasiMeta(QuasiDataObj, p.Results.ApproxType, 'exclusionRadius');

        parfor  j = 1:length(exclusionRadius)
            % Fetch output from the QuasiDataObj and assign the output to a par-output catcher
            ParDataOutput{j} = QuasiDataObj.estimateStreamFunction('solveOrder', solveOrder(i), 'approximationType', 'B', ...
                                'exclusionRadius', exclusionRadius(j), 'errorTol', 1e-4, 'fminGuess', CoeffGuess{j});
        end

        
        for     j = 1:length(exclusionRadius)

            % Post-parloop, append all the results to the QuasiMetaObject
            QMO.appendCoefficientStruct(ParDataOutput{j}, exclusionRadius(j));

            % Update the coefficient guesses using the previous result, and add new guesses for the next orders
            CoeffGuess{j} = QMO.Coefficients{j};
            CoeffGuess{j} = [CoeffGuess{j}(1:end-1), 10^solveOrder(i), 10^(solveOrder(i) + 1), CoeffGuess{j}(end)];
        end

        % Assign to output struct    
        QMO_Struct{i} = QMO;
    end
end