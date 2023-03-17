%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ======================= CLASS: VELOCITYDATA =============================
%
% Class to encapsulate methods on VelocityData
%
% MEMBER VARIABLES
%   velocityPlaneCartesian      - Velocity data in array with size (n_x, n_y, 2)
%                                   where (x, y, 1) returns ux and (x, y, 2) returns uy.
%   velocityPlanePolar          - Velocity data in array with size (n_x, n_y, 2)
%                                   where (x, y, 1/2) returns ur/ut.



classdef VelocityData < LudwigData
    properties
        velocityYZPlane                                 % Cartersian velocity plane of the form (x, z, t_step)
        velocityPlaneCartesian       {mustBeNumeric}     % Cartesian velocity plane of form (x, y, u)
        velocityPlanePolar           {mustBeNumeric}     % Polar velocity plane of the form (x, y, u)
        x0                           {mustBeNumeric}     % Colloid x position at time step
        y0                           {mustBeNumeric}     % Colloid y position at time step
        z0                           {mustBeNumeric}     % Colloid z position at time step
        X                            {mustBeNumeric}     % X Carterisian coordinates for velocity plane
        Y                            {mustBeNumeric}     % Y Carterisian coordinates for velocity plane
        Z                            {mustBeNumeric}     % Z Carterisian coordinates for XZ velocity plane
        R                            {mustBeNumeric}     % R polar coordinates for velocity plane
        Th                           {mustBeNumeric}     % Theta polar coordinates for velocity plane
        timeStep
        extractHeight
    end
    
    % Defined externally
    methods
        extractYZPlane(this, t_idx, z_idx, x_range, y_range);
        convertPolar(this, x0, y0);
    end

    methods
        
        

        function checkForCartesianPlane(this)
            % checkForCartesianPlane(this)
            %
            % Checks for the existence of velocityPlaneCartesian.
            % Throws error if plane isn't extracted
            if isempty(this.velocityPlaneCartesian)
                error('Cartesaian velocity plane not extracted');
            end
        end

        function checkForPolarPlane(this)
            % checkForPolarPlane(this)
            %
            % Checks for the existence of velocityPlanePolar.
            % Throws error if plane isn't extracted.
            if isempty(this.velocityPlanePolar)
                error('Polar velocity plane not extracted');
            end
        end

        function Vbar = avgSimulationVelocity(this)
            % avgSimulationVelocity
            %
            % Fetch the average simulation velocity, Vbar, over all latice points.
            
            % Check for cartesianPlane existance
            this.checkForCartesianPlane;

            % Sum over all lattice points          
            Vsx = this.velocityPlaneCartesian(:, :, 1);
            Vsy = this.velocityPlaneCartesian(:, :, 2);

            Vbar = 0;
            
            for i = 1:length(Vsx)
                Vbar = Vbar + sqrt(Vsx(i).^2 + Vsy(i).^2);
            end


            % Divide by total number of points for Vbar
            Vbar = Vbar/length(Vsx);
        end
    end


    % Declare graphing methods
    methods
        fig = graphVelocitySurface(this, velComponentStr);
        fig = graphQuiver(this);
        fig = graphStreamlines(this);
        fig = graph3DVelocity(this);
    end
    
    % Helper method to find channel runs
    methods (Access = public)
        idxList = findChannelRuns(this);
    end
end


