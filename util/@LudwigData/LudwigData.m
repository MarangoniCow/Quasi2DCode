%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ======================== CLASS: LUDWIGDATA ==============================
%
% Class to encapsulate velocity and colloid data from a Ludwig simulation
% for processing and visualisation using native MATLAB tools.
%
% LudwigObj = LudwigData(folderStr, seriesID)
%   Initialises a LudwigData object with the folder containing the Ludwig data and the identifying ID for the
%   simulation series.
%
% LudwigObj = LudwigData(folderStr)
%   Initialise a LudwigData object with seriesID = '#'.
%
% MEMBER VARIABLES
%   seriesID        -   string, shorthand ID identifying simulation series
%   folderStr       -   string, data location
%   systemSize      -   3-by-1 array containing system size (n_x, n_y, n_z)
%   velocityData    -   matrix of dimension (n_x, n_y, n_z, 3) containing
%                           fluid velocity values
%   colloidDisp     -   colloid displacement values
%   colloidVel      -   colloid velocity values
%   colloidRadius   -   colloidRadius
%
% MEMBER FUNCTIONS
%   LudwigData(folderStr, seriesID)
%                   - Assigns folder string and series ID
%   setSysDim(this, x, y, z)
%                   - Assigns n_x, n_y, n_z
%   extractColloid(this)
%                   - Extract colloidal displacement and velocity
%   extractVelocity(this)
%                   - Extract velocity field 


classdef LudwigData < matlab.mixin.SetGet
    properties 
        seriesID        char                    % Simulation series name
        folderStr       char                    % String to folder containing Ludwig ASCII data
        systemSize      {mustBeInteger}         % (3, 1) Array containing system x, y, z sizes (L, W, H)
        colloidDisp     {mustBeNumeric}         % {n}(3, T) array for nth colloid x, y, z, displacement at time T
        colloidVel      {mustBeNumeric}         % {n}(3, T) array for nth colloid u, v, w, velocity at time T
        colloidRadius   (1, 1){mustBeNumeric}   % Colloid radius
        velocityData    {mustBeNumeric}         % {t}(x, y, z, 3) array for cartesian velocity at point (x, y, z) at time t

    end
    methods
        function this = LudwigData(folderStr, seriesID)
            if nargin == 0
                error('LudwigData must be initialised with a target directory containing Ludwig simulation data');
            elseif nargin >= 1
                validateattributes(folderStr, 'char', {'scalartext'});

                if ~isfolder(folderStr)
                    error('Expected directory as first argument')
                else
                    this.folderStr = folderStr;
                end

                if nargin == 2
                    validateattributes(seriesID, 'char', {'scalartext'})
                    this.seriesID = seriesID;
                else
                    this.seriesID = '#';
                end
            end
        end
        
        function setSysDim(this, L, W, H)
        % setSysDim(this, L, W, H) - Sets the length, width and height corresponding to the LB-simulation

            this.systemSize(1) = L;
            this.systemSize(2) = W;
            this.systemSize(3) = H; 
        end
               
        function checkSysDim(this)
        % checkSysDim(this)     - Checks to see if the system size is set

            if isempty(this.systemSize)
                error('System dimensions unknown: set using setSysDim');
            end
        end

        function checkVelocityData(this)
        % checkVelocityData(this) - Check if any velocity data has been extracted

            if isempty(this.velocityData)
                error('Velocity data not extracted')
            end
        end        
    end
    
    % ======================================================= %
    %   Externally defined methods
    % ======================================================= %
    methods 
        extractColloid(this);
        extractVelocity(this, t);
    end

end
