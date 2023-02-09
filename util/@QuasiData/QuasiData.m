%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ========================== CLASS: Q2DDATA ===============================CoeffApsi_A
%
% Class to encapsulate methods for Quasi-2D parameter estimations
%
% MEMBER VARIABLES
%   - VelData               VelocityData object
%   - CoeffB                Second approximation coefficients
%   - CoeffA                First approximation coefficients
%   - psi_B                 Second approximation streamfunction
%   - psi_A                 First approxximation streamfunction
%   - lambda                `Screening' parameter
%   - colloidRadius         Colloid radius, used in fitting
%   - colloidVelocity       Colloid velocity, used in fitting
%
% MEMBER FUNCTIONS
%   - esimateStreamFunction(this)   Estimate the A & B streamfunction
%   - streamFunction_A            Return the first analytically-determined streamfunction
%   - streamFunction_B            Return the second analytically-determined streamfunction
%   - checkForVelData               Throws error if VelData not set

classdef QuasiData < matlab.mixin.SetGet

    properties
        VelData             % VelocityData object
        CoeffA              % A-field coefficients
        CoeffB              % B-field coefficients
        psi_B
        psi_A
        stats_B
        stats_A
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
            if isempty(this.CoeffA) || isempty(this.CoeffB)
                error('Parameters undefined');
            end
        end
    end
    
    % Stream function methods
    methods
        psi = streamFunction_A(this, R, Th);
        psi = streamFunction_B (this, R, Th);
        [ur, ut] = velocityField_B(this, R, Th);
        [ur, ut] = velocityField_A(this, R, Th);
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
