


folderStr = ['/Development/repos/Quasi2DCode/Data'];
fileNames = {'3DP_Pu_Q2D_W_01.mat', '3DP_Pu_Q2D_W_04.mat' '3DP_Pu_Q2D_W_07.mat' ..., 
            '3DP_Pu_Q2D_W_11.mat' '3DP_Pu_Q2D_W_15.mat'};

% fileNames = {'3DP_Pu_Q2D_W_01.mat', '3DP_Pu_Q2D_W_15.mat'};
exclusionRadius = 1:30;

QMO_Struct = cell(1, length(fileNames));
CoeffCell = cell(1, length(exclusionRadius));

for i = 1:length(exclusionRadius)
    load(fullfile(folderStr, fileNames{i}));
    
    
    QMO = QuasiMeta(QuasiObj, 'B', 'exclusionRadius');


    parfor j = 1:length(exclusionRadius)
        
        CoeffStruct = QuasiObj.estimateStreamFunction('solveOrder', 5, 'approximationType', 'B', 'exclusionRadius', exclusionRadius(j), 'errorTol', 1e-5);
        CoeffCell{j} = CoeffStruct;
    end

    for j = 1:length(exclusionRadius)
        QMO.appendCoefficientStruct(CoeffCell{j}, exclusionRadius(j));
    end

    QMO_Struct{i} = QMO;

end

beep; pause(1); beep; pause(1); beep;