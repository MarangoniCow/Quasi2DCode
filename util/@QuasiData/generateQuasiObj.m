
function QuasiObj = generateQuasiObj(FolderStr, SystemSize, varargin)
    % ------------------------------------------------------------- %
    % ------------------------------------------------------------- %
    %       INITIALISE QUASI-PARAMETER FITTING VARIABLES 
    %
    % Initialise a QuasiData object from a LudwigData object
    % 
    % ------------------------------------------------------------- %
    % ------------------------------------------------------------- %



    % Parse inputs
    p = inputParser;

    % Folder string
    addRequired(p, 'FolderStr');

    % System size
    addRequired(p, 'SystemSize', @(x) isnumeric(x) && length(x) == 3);

    % Fetch common args
    p = QuasiData.CommonQuasiArg(p);

    % Parse inputs
    parse(p, FolderStr, SystemSize, varargin{:});


    % ------------------------------------------------------------- %
    %   Methodology:
    %       1) Initialise a velocity data object from the folder
    %       2) Set as many dependents as possible
    % ------------------------------------------------------------- %
    

    % Initialise VelocityData
    VelObj = VelocityData(FolderStr, p.Results.SimulationName);
    
    
    % Set system size
    if(~isempty(p.Results.SystemSize))
        simSize = p.Results.SystemSize;
        setSysDim(VelObj, simSize(1), simSize(2), simSize(3));
    end

    % Extract colloid displacement
    VelObj.colloid_a = p.Results.ColloidRadius;
    VelObj.extractColloid;
    

    % z_idx
    cs = VelObj.colloidDisp(1, :);
    

    % If not specificed, calculate the best timestep
    if any(strcmp(p.UsingDefaults, 'TimeStep'))
        idxList = VelObj.findChannelRuns;

        if isempty(idxList)
            t = length(VelObj.velocityData);
        else

            for i = 1:length(idxList)
                runStart = idxList{i}(1);
                runEnd = idxList{i}(end);
                runPercent{i} = (cs(runEnd) - cs(runStart))/VelObj.systemSize(1);
            end
    
            if(runPercent{end} > 0.8)
                runIdx = length(idxList);
            else
                runIdx = length(idxList) - 1;
            end
    
            % Use the second to last channel run *** potential bug *** 
            channelRun = VelObj.colloidDisp(1, idxList{runIdx});
            midChannel = VelObj.systemSize(1)/2;
            t = closestelement(channelRun, midChannel) + idxList{runIdx - 1}(end);
        end
    else
        t = p.Results.TimeStep;
    end
        

    x0 = VelObj.colloidDisp(1, t);
    y0 = VelObj.colloidDisp(2, t);
    z0 = VelObj.colloidDisp(3, t);
    zidx = closestelement(1:VelObj.systemSize(3), z0);

    if any(strcmp(p.UsingDefaults, 'PlaneExtractIdx'))
        x_range = 1:VelObj.systemSize(1);
        y_range = 1:VelObj.systemSize(2);
    else
        x_range = p.Results.PlaneExtractIdx{1}; 
        y_range = p.Results.PlaneExtractIdx{2}; 
    end
    
    VelObj.extractVelocity(t);
    
    % Extract velocity plane
    VelObj.extractXYPlane(t, zidx, x_range, y_range);

    % Extract YZ plane
    a = p.Results.ColloidRadius;
    z_range = 1:VelObj.systemSize(3);
    xidx = floor(x0 - 6*a):3*floor(a):floor(x0 + 6*a);
    VelObj.extractYZPlane(t, xidx, y_range, z_range);
    
    % Convert to polar
    convertPolar(VelObj, x0, y0);
    QuasiObj = QuasiData(VelObj);

    % Assign remaining QuasiObj variables
    QuasiObj.lambda = sqrt(VelObj.systemSize(3)^2/12);
    QuasiObj.colloidRadius = a;
    U = VelObj.colloidVel(:, VelObj.timeStep);
    QuasiObj.colloidVelocity = sqrt(dot(U, U));

    

    % Delete raw data if requested
    if ~p.Results.RetainVelData
        VelObj.velocityData = [];
        QuasiObj.VelData.velocityData = [];
    end

    
end
