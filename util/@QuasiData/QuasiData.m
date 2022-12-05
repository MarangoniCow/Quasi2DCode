%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ========================== CLASS: Q2DDATA ===============================
%
% Class to encapsulate methods for Quasi-2D parameter estimations
%
% MEMBER VARIABLES
%   - VelData               VelocityData object
%   - B_near                Near-field coefficients
%   - B_far                 Far-field coefficients
%   - psi_near              Fitted near-field streamfunction
%   - psi_far               Fitted far-field streamfunction
%   - lambda                `Screening' parameter
%   - colloidRadius         Colloid radius, used in fitting
%   - colloidVelocity       Colloid velocity, used in fitting
%
% MEMBER FUNCTIONS
%   - esimateStreamFunction(this)   Estimate the near & farfield streamfunction
%   - nearStreamFunction            Return the analytically-determined
%                                   near-streamfunction
%   - farStreamFunction             Return the analytically-determined
%                                   far-streamfunction
%   - checkForVelData               Throws error if VelData not set

classdef QuasiData < matlab.mixin.SetGet

    properties
        VelData             % VelocityData object
        B_far               % Far-field coefficients
        B_near              % Near-field coefficients
        psi_near
        psi_far
        lambda
        colloidRadius
        colloidVelocity
    end

    methods

        function this = QuasiData(VelData)
            % Set velocity data
            this.VelData = VelData;
        end

        function checkForVelData(this)
            if isempty(this.VelData)
                error('VelocityData object uninitiated');
            end
        end

        function checkForParameters(this)
            if isempty(this.B_far) || isempty(this.B_near)
                error('Parameters undefined');
            end
        end
    end
    
    % Stream function methods
    methods
        psi = nearStreamfunction(this, R, Th);
        psi = farStreamFunction (this, R, Th);
        [ur, ut] = nearVelocityField(this, R, Th);
        [ur, ut] = farVelocityField(this, R, Th);
    end
    
    % Graphing methods
    methods
        fig = graphStreamfunction(this, fcnName);
        fig = graphStreamlines(this, fcnName);
        fig = graphResidues(this, fcnName);
    end

    methods (Access = private)
        p = parseFunctionNames(p);
    end
end