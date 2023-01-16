%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           LOAD SIMULATION SERIES
%
%   Load Ludwig simulation data from a directory and save it as a .mat
%   file.


% USAGE:
%   1) Set the root folder. It is expected that this folder will contain
%   directories of the form, './series_id_01/data/'
%   2) Set the series names
%   3) Set the system size and colloid radius
%   4) Set save location
%   5) Set how much of the plane I want to extract

% VARARGIN (name-value pairs)
%   - ColloidRadius         Set the radius of the colloid
%   - PlaneExtractIdx       Set the idx of the desired plane
%   - SimulationName        Series name
%   - RetainVelData         Option to delete data if only interested in a
%                           plane



function S = loadSimulationSeries(RootFolder, FolderPattern, SystemSize, SaveLocation, varargin)

    % Input parser
    p = inputParser;

    % Required arguments
    addRequired(p, 'RootFolder');
    addRequired(p, 'FilePattern');
    addRequired(p, 'SystemSize');
    addRequired(p, 'SaveLocation')

    % Fetch common arguments
    p = CommonQuasiArg(p);

    % Parse inputs
    parse(p, RootFolder, FolderPattern, SystemSize, SaveLocation, varargin{:});

    




    % ------------------------------------------------------------------- %
    %   Fetch folder names
    % ------------------------------------------------------------------- %
    f = fullfile(RootFolder, FolderPattern);
    S = dir(f);

    idx = [];
    for i = 1:length(S)
        if S(i).isdir && strcmp({'.'}, S(i).name)
            idx = [idx, i];
        end
    end
    S = S(idx);
    N = length(S);

    % ------------------------------------------------------------------- %
    %   Validate system size information
    % ------------------------------------------------------------------- %
    
    % Cast to int
    SystemSize = int16(SystemSize);
    validateattributes(SystemSize, 'int16', {'size', [NaN, 3], '>', 0})
    [M, ~] = size(SystemSize);
    if M ~= N && M ~= 1
        error('Expected SystemSize to be 1x3 or Nx3, where N is number of simulations');
    elseif M == 1
        for i = 1:N
            SystemSize(i, :) = SystemSize(1, :);
        end
    end


    for i = 1:N
        disp(fetchSimulationName(S(i).folder))
    end


    % ------------------------------------------------------------------- %
    %   Additional argument validation
    % ------------------------------------------------------------------- %

    % Simulation name should be determined dynamically
    if (~strcmp('SimulationName', p.UsingDefaults))
        error('SimulationName must be determined dynamically');
    end

    % ------------------------------------------------------------------- %
    %   Pass all varargin to QP_initialise and save the data
    % ------------------------------------------------------------------- %

    for i = 1:N

        [QuasiObj, ~] = QP_initialise(S(i).folder, SystemSize(i, :), ...
                        'SimulationName', fetchSimulationName(S(i).folder), ...
                        varargin{:});

        if(~p.Results.RetainVelData)
            QuasiObj.VelData.velocityData = [];
        end
        
        save(fullfile(SaveLocation, QuasiObj.VelData.seriesID), 'QuasiObj', '-v7.3')
    end


    function substr = fetchSimulationName(str)

        % Remove '/data'
        str = str(1:end - 5);
        
        % Assume we're being passed a folder name, i.e. /foo1/foo2/foo3
        % where foo3 is the simulation name.
        id = length(str);
        substr = '';
        found = false;

        while(~found)

            if strcmp(str(id), filesep) || id == 1
                found = true;
            else
                substr = [str(id), substr];
                id = id - 1;
            end
        end
    end

end