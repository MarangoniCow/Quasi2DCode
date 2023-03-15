function extractColloid(LudwigDataObj)
% extractColloid(LudwigDataObj)  - Extracts Ludwig colloid data.
%
% extractColloid seeks .csv files in the directory provided by LudwigData.folderStr and extracts the data into the
% LudwigDataObj.

               
    filePattern = fullfile(LudwigDataObj.folderStr, '*.csv');
    S = dir(filePattern);
    n = length(S);
    
    col_disp_cell = zeros(3, n);
    col_vel_cell = zeros(3, n);

    fileName = cell(1, n);
    
    for i = 1:n
        fileName{i} = [LudwigDataObj.folderStr, '/', S(i).name];
    end
                
    
    for i = 1:n
        C = extractColloidCSVData(fileName{i});
        col_disp_cell(:, i) = C{1};
        col_vel_cell(:, i) = C{2};
    end

    LudwigDataObj.colloidDisp = col_disp_cell;
    LudwigDataObj.colloidVel = col_vel_cell;
end