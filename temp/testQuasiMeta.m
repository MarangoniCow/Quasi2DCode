

solveOrder = [2, 3, 4, 5, 6, 7, 8];

folderStr = ['/Development/repos/Quasi2DCode/Data'];
fileNames = {'3DP_Pu_Q2D_W_01.mat', '3DP_Pu_Q2D_W_03.mat', '3DP_Pu_Q2D_W_05.mat', ...
                '3DP_Pu_Q2D_W_07.mat', '3DP_Pu_Q2D_W_09.mat'};

colloidRadius = 11.33;

exclusionRadius = 1:1:floor(4*colloidRadius);



for k = 1:length(fileNames)

    load(fullfile(folderStr, fileNames{k}));

    QMO_Struct = cell(1, length(solveOrder));
    str = ['QMO_H_', num2str(solveOrder(k))];


    CoeffCell = cell(1, length(exclusionRadius));

    for i = 1:length(solveOrder)
        
        
        
        
        QMO = QuasiMeta(QuasiObj, 'B', 'exclusionRadius'); 
    
    
        parfor j = 1:length(exclusionRadius)
            
            CoeffStruct = QuasiObj.estimateStreamFunction('solveOrder', solveOrder(i), 'approximationType', 'B', 'exclusionRadius', exclusionRadius(j), 'errorTol', 1e-4);
            CoeffCell{j} = CoeffStruct;
        end
    
        for j = 1:length(exclusionRadius)
            QMO.appendCoefficientStruct(CoeffCell{j}, exclusionRadius(j));
        end
    
        QMO_Struct{i} = QMO;
    
    end

    save(str, 'QMO_Struct');

end

beep; pause(1); beep; pause(1); beep;