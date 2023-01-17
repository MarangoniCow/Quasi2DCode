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
        PlaneExtractIdx{1} = 1:384;
        PlaneExtractIdx{2} = 28:227;
        
        ColloidRadius   = 11.33;  
        
        RetainVelData   = false;
        
        saveLocation    = '../Data';
    
    
    % ----------------------------------------------------------------------- %
    %   Series specific information can be input here
    % ----------------------------------------------------------------------- %
    
    % IGNORED
    switch(-1)
        case 1
          	SystemSize      = [384, 256, 48];
        case 2
            SystemSize      = [384, 256, 56];
        case 3
            SystemSize      = [384, 256, 64];
        case 4
            SystemSize      = [384, 256, 72];
        case 5
            SystemSize      = [384, 256, 80];
        case 6
            SystemSize      = [384, 256, 88];
        case 7
            SystemSize      = [384, 256, 96];
        case 8
            SystemSize      = [384, 256, 104];
        case 9
            SystemSize      = [384, 256, 112];
        case 10
            SystemSize      = [384, 256, 120];
        case 11
            SystemSize      = [384, 256, 128];
        case 12
            SystemSize      = [384, 256, 136];
        case 13
            SystemSize      = [384, 256, 144];
        case 14
            SystemSize      = [384, 256, 152];
        case 15
            SystemSize      = [384, 256, 160];
        otherwise
            error('Undetermined system size')
    end




    SystemSize      = [384, 256, 64];

    
    
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
