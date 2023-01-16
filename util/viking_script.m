function viking_script(SCRIPTNAME)




    % ----------------------------------------------------------------------- %
    % ----------------------------------------------------------------------- %
    %                               EDIT ME                                   %
    %   Set undesired options to []
    % ----------------------------------------------------------------------- %
    % ----------------------------------------------------------------------- %
    
    RootFolder  = '~/scratch/ludwig/examples';
    
    folderName   = [SCRIPTNAME, '/data'];
    
    
    % ----------------------------------------------------------------------- %
    %   Output RootFolder + FolderPattern
    % ----------------------------------------------------------------------- %
    disp(fullfile(RootFolder, folderName));
    
    % ----------------------------------------------------------------------- %
    %   Extract meta data from filename
    % ----------------------------------------------------------------------- %
    seriesNumber = SCRIPTNAME(end-1:end);

	disp(['Series number: ', seriesNumber])
    
    
    % ----------------------------------------------------------------------- %
    %   Series non-specific information can be defined here
    % ----------------------------------------------------------------------- %
        PlaneExtractIdx{1} = 1:50;
        PlaneExtractIdx{2} = 10:40;
        
        ColloidRadius   = 3;  
        
        RetainVelData   = false;
        
        saveLocation    = '../Data';
    
    
    % ----------------------------------------------------------------------- %
    %   Series specific information can be input here
    % ----------------------------------------------------------------------- %
    
    
    switch(str2num(seriesNumber))
        case 1
          	SystemSize      = [384, 256, 48];
        case 2
            SystemSize      = [384, 256, 54];
        case 3
            SystemSize      = [384, 256, 60];
        case 4
            SystemSize      = [384, 256, 68];
        case 5
            SystemSize      = [10, 10, 10];
        case 6
            SystemSize      = [10, 10, 10];
        case 7
            SystemSize      = [10, 10, 10];
        case 8
            SystemSize      = [10, 10, 10];
        case 9
            SystemSize      = [10, 10, 10];
        case 10
            SystemSize      = [10, 10, 10];
        case 11
            SystemSize      = [10, 10, 10];
        case 12
            SystemSize      = [10, 10, 10];
        case 13
            SystemSize      = [10, 10, 10];
        case 14
            SystemSize      = [10, 10, 10];
        case 15
            SystemSize      = [10, 10, 10];
        otherwise
            error('Undetermined system size')
    end
    
    
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
    
    
    loadSimulationSeries(RootFolder, folderName, SystemSize, saveLocation, ...
                        'ColloidRadius', ColloidRadius, 'RetainVelData', RetainVelData, ...
                        'PlaneExtractIdx', PlaneExtractIdx);








end
