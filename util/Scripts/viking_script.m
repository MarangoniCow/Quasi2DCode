function viking_script(SCRIPTNAME, VAR)

% VIKING_SCRIPT(SCRIPTNAME)
%
%
% WARNING: NOT A STAND-ALONE FUNCTION. MUST BE EXPLICITLY CONFIGURED FOR EACH USE
% CASE. CAN USE THE SERIES NUMBER TO INCLUDE OR EXCLUDE EXTRA INFORMATION.




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
    
    ColloidRadius   = 11.33;  
    RetainVelData   = true;
    saveLocation    = '../Data';

    switch VAR
        
        case 'XL'
            
            SystemSize              = [1600, 600, 48];
            PlaneExtractIdx{1} = 1:1600;
            PlaneExtractIdx{2} = 1:600;

        case 'H'
            SystemSize = [384, 256, 64];
            PlaneExtractIdx{1} = 1:384;
            PlaneExtractIdx{2} = 1:256;

        case 'W'

            PlaneExtractIdx{1} = 1:384;
            PlaneExtractIdx{2} = 1:256;

            switch(str2num(seriesNumber))
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
		        warning('Using default system size')
            end
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
    
    
    QuasiObj = loadSimulationSeries(RootFolder, folderName, SystemSize, saveLocation, ...
                        'ColloidRadius', ColloidRadius, 'RetainVelData', RetainVelData, ...
                        'PlaneExtractIdx', PlaneExtractIdx);

    % ----------------------------------------------------------------------- %
    %   We can also estimate coefficients here, if we so wish
    % ----------------------------------------------------------------------- %

    QMO_Struct = QuasiMeta.generateQuasiCoefficients(QuasiObj, 'solveOrder', [2, 4, 6]);

    str = [QuasiObj.VelData.seriesID, '_META'];
    save(fullfile(saveLocation, str), 'QMO_Struct', '-v7.3')








end
