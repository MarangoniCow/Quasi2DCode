%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ========================== CLASS: QUASI2DDATA ===============================
%
% Class to encapsulate methods for Quasi-2D parameter estimations
%
% MEMBER VARIABLES
%   - VelData                   VelocityData object
%   - Coeff                     Approximation coefficients
%   - lambda                    `Screening' parameter
%   - colloidVelocity           Colloid velocity, used in fitting
%
% MEMBER FUNCTIONS
%   - esimateStreamFunction     Approximate the streamfunction for the flow

classdef QuasiData < matlab.mixin.SetGet

    properties
        VelData             % VelocityData object
        Stats
        Fminsum
        Coeff
        lambda
        colloidVelocity
    end

    methods

        function this = QuasiData(VelData)
            % Constructor which sets a reference to VelData
            this.VelData = VelData;
        end

        function checkForVelData(this)
            % Check for existence of a VelData object
            if isempty(this.VelData)
                error('VelocityData object uninitiated');
            end
        end

        function checkForParameters(this)
            % Check if coefficients have been determined      
            if isempty(this.Coeff)
                error('Undetermined Coefficients')
            end
        end

        function [Th, R] = colloidCoordinateTransformation(this, xt, yt)
            % Coordinate transformation for a colloid placed at (xt, yt)
            [Th, R] = cart2pol(this.VelData.X - xt, this.VelData.Y - yt);
        end
    end
        
    % EXTERNALLY-DEFINED METHODS
    methods
        [ux, uy] = quasi2DVelocity(this, B, r, theta, bool); 
        fig = graphStreamfunction(this, fcnName);
        fig = graphStreamlines(this, fcnName);
        fig = graphResidues(this, fcnName);
    end

    methods (Static)
        p = CommonQuasiArg(p);
        QuasiObj = generateQuasiObj(FolderStr, SystemSize, varargin);
    end

end
