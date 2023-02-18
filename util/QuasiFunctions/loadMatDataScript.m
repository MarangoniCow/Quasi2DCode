
function loadMatDataScript

% loadMatData Script: Load all the data files matching a certain pattern
% and do something with them.



% Set pattern
rootFolder  = '~/Development/repos/Quasi2DCode/Data/';
filePattern = '3DP_Pu_Q2D_W_*.mat';
nameFile = fullfile(rootFolder, filePattern);
S = dir(nameFile);

% Specifics
saveFolder = '~/Development/repos/Quasi2DCode';

for i = 1:length(S)
    load(fullfile(S(i).folder, S(i).name));

    QuasiObj.estimateStreamFunction(2);

%     save(fullfile(saveFolder, S(i).name), 'QuasiObj')


end

end