function QMO_Struct = generateQuasiCoefficients(QuasiDataObj)
    % GENERATEQUASICOEFFICIENTS(QuasiDataObj)
    %
    % Generate a range of coefficients to be stored in a QuasiDataObj. 


    colloidRadius = QuasiDataObj.colloidRadius;
    exclusionRadius = 1:2:floor(4*colloidRadius);
    solveOrder = [2, 4, 6, 8];

    QMO_Struct = cell(1, length(solveOrder));
    CoeffCell = cell(1, length(exclusionRadius));

    guess = cell(1, length(solveOrder));
    

    for i = 1:length(exclusionRadius)
        guess{i} = [1.2, 110, 0.1];
    end

    for i = 1:length(solveOrder)

        QMO = QuasiMeta(QuasiDataObj, 'B', 'exclusionRadius');

        parfor j = 1:length(exclusionRadius)
    
            CoeffStruct = QuasiDataObj.estimateStreamFunction('solveOrder', solveOrder(i), 'approximationType', 'B', ...
                            'exclusionRadius', exclusionRadius(j), 'errorTol', 1e-4, 'fminGuess', guess{j});
            CoeffCell{j} = CoeffStruct;
        end
    
        for j = 1:length(exclusionRadius)
            QMO.appendCoefficientStruct(CoeffCell{j}, exclusionRadius(j));
            guess{j} = QMO.Coefficients{j};
            guess{j} = [guess{j}(1:end-1), 10^solveOrder(i), 10^(solveOrder(i) + 1), guess{j}(end)];
        end
    
        QMO_Struct{i} = QMO;

    end

end