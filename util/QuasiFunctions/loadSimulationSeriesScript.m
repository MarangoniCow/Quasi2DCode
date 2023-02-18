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

function loadSimulationSeries(RootFolder, FilePattern, varargin)

    % Parse inputs
    p = inputParser;

    % Root folder
    addRequired(p, 'RootFolder');

    % String to match
    addRequired(p, 'FilePattern');

    % System size information
    addOptional(p, 'SystemSize');

    % Colloid radius information
    addOptional(p, 'ColloidRadius');

    % Define plane extraction
    addOptional(p, 'PlaneExtractIdx');



    




    %   1) Root folder
    RootFolder = '/home/matthew/Documents/ludwig_viking_data/';
    Data = '/data';
    %   2) Series names
    Series =        [
                    '3DP_Pu_Q2D_W_13';
                    '3DP_Pu_Q2D_W_14';
                    '3DP_Pu_Q2D_W_15';
                    ];
    %   3) System information
    [row, ~] = size(Series);
    SystemSize = zeros(row, 3);
    j = 1;
    for i = 48:8:136
        SystemSize(j, :) = [256, 200, i];
        j = j + 1;
    end
    
    
    colloidRadius = 11.33;
    
    %   4) Save location
    savelocation = '../Data/';
    
    %   5) Plane extract idx
    planeExtractIdx{1} = 1:256;
    planeExtractIdx{2} = 20:180;
    
    
    % Everything is done dynamically
    for i = 1:row
    
        % Fetch folder string
        folderStr = [RootFolder, Series(i, :), Data];
        % Fetch QP initialise
        [QuasiObj, VelObj] = QP_initialise(folderStr, SystemSize(i, :),  'SimulationName', Series(i, :), 'ColloidRadius', 11.33);
       
        % Save data
        save([savelocation, VelObj.seriesID], 'QuasiObj', 'VelObj', '-v7.3')
end


end