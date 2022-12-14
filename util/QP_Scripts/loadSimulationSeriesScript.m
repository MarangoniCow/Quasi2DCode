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



%   1) Root folder
RootFolder = '/users/mjs572/scratch/ludwig/examples/';
Data = '/data';
%   2) Series names
Series =        [
                '3DP_Pu_Q2D_W_01';
                '3DP_Pl_Q2D_W_01';
                ];
%   3) System information
[row, ~] = size(Series);
SystemSize = [256, 200, 52];
colloidRadius = 11.33;

%   4) Save location
savelocation = '../Data/';


% Everything is done dynamically
for i = 1:row

    % Fetch folder string
    folderStr = [RootFolder, Series(i, :), Data];
    % Fetch QP initialise
    [QuasiObj, VelObj] = QP_initialise(folderStr, SystemSize,  'SimulationName', Series(i, :), 'ColloidRadius', 11.33);
    % Save data
    save([savelocation, VelObj.seriesID], 'QuasiObj', 'VelObj', '-v7.3')
end