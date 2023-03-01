QMO_Struct = cell(1, 8);

folderStr = 'Development/repos/Quasi2DCode/Data/';
CoeffStruct = cell(1, 8);


for i = 1:8
    fileName = ['3DP_Pu_Q2D_H1_0', num2str(i), '.mat'];
    load(fullfile(folderStr, fileName));
    QMO_Struct{i} = QuasiObj;
end


parfor i = 1:8
    CoeffStruct{i} = QuasiStruct{i}.estimateStreamFunction;

end


    