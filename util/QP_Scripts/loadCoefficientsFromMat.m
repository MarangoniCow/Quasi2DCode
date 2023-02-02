clearvars;

% File names to load
fileNames = [
            '3DP_Pu_Q2D_W_04';
            '3DP_Pu_Q2D_W_05';
            '3DP_Pu_Q2D_W_06';
            '3DP_Pu_Q2D_W_07';
            '3DP_Pu_Q2D_W_08';
            '3DP_Pu_Q2D_W_09';
            '3DP_Pu_Q2D_W_10';
            '3DP_Pu_Q2D_W_11';
            '3DP_Pu_Q2D_W_12';
            ];

% Data location
folderStr = '../Data/';

% Initialise variables
l = length(fileNames);


for i = 1:l
    load([folderStr, fileNames(i, :)], 'QuasiObj');
    coefficients{i} = QuasiObj.CoeffB;
    seriesID{i} = QuasiObj.VelData.seriesID;
end
    