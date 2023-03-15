function extractVelocity(this, t)
    % extractVelocity(this, t)  - extract Ludwig velocity data
    %
    % extractVelocity extracts the velocity data from a Ludwig simulation in the directory provided by
    % LudwigData.folderStr.
    
    % Check system dimensions before proceeding
    checkSysDim(this);
    Sx = this.systemSize(1);
    Sy = this.systemSize(2);
    Sz = this.systemSize(3);

    % Fetch file names from folder    
    filePattern = fullfile(this.folderStr, 'vel-*');
    S = dir(filePattern);

    % ASCII files have no extension, so we double check we don't
    % have any extensions and delete.
    hasDot = contains({S.name}, '.');
    S(hasDot) = [];

    % Initialise necessary variables for extraction
    n = length(S);
    this.velocityData = cell(n, 1);
    fileName = cell(n, 1);

    
    % Extract data
    for i = 1:n
        fileName{i} = [this.folderStr, '/', S(i).name];
    end
    
    if nargin == 2
            this.velocityData{t} = extractVelocityASCIIData(fileName{t}, Sx, Sy, Sz);
    else
        for i = 1:n
            this.velocityData{i} = extractVelocityASCIIData(fileName{i}, Sx, Sy, Sz);
        end
    end
end