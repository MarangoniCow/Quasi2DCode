

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
%                               EDIT ME                                   %
%   Set undesired options to []
% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
clearvars;

RootFolder  = '~/Development/repos/ludwig/examples';

FolderPattern   = 'Colloid*/data';

PlaneExtractIdx{1} = 1:10;
PlaneExtractIdx{2} = 2:8;

ColloidRadius   = 3;

SystemSize      = [10, 10, 10];

RetainVelData   = false;

saveLocation    = '../Data';


% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
%                       DON'T EDIT FROM HERE ONWARD                       %
% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %


% Check we're in /util
p = pwd;

if ~strcmp(p(end-3:end), 'util')
    error('Script must be run from util as working directory')
end


loadSimulationSeries(RootFolder, FolderPattern, SystemSize, saveLocation, ...
                    'ColloidRadius', ColloidRadius, 'RetainVelData', RetainVelData, ...
                    'PlaneExtractIdx', PlaneExtractIdx);


