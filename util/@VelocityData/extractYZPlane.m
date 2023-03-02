function extractYZPlane(this, t_idx, x_idx, y_range, z_range)
        % extractPlane(this, t_idx, z_idx)
        %
        % Extracts the XZ plane perpendicular to the XY plane.
        % Should only be run if velocityPlane has already been extracted.
        % 
        % INPUTS
        %   this        - VelocityData object
        %   t_idx       - Point of time of interest
        %   y_idx       - Y points of interest
        %   x_rangevelocityYZPlane     - (opt) Range of x
        %   z_range     - (opt) Range of z
        % OUTPUTS
        %   Writes output to this.velocityYZPlane

        % Check system dimensions are defined before proceeding
        checkSysDim(this);

        % Check for velocity data extraction
        try
            this.checkVelocityData;
        catch
            this.extractVelocity;
        end

        % If not defined, validate x_range and y_range
        if nargin <= 3
            t_idx = this.timeStep;
            x_idx = round(this.colloidDisp(1, this.timeStep), ;
            y_range = 1:this.systemSize(2);
            z_range = 1:this.systemSize(3);
        else
            % NEED BETTER ERROR CHECKING HERE
        end
        

        
        % Initialise data types
        for i = 1:length(x_idx)
            this.velocityYZPlane{i} = zeros(length(y_range), length(z_range));
            
            % Extract velocity data from LudwigData datatype 
            this.velocityYZPlane{i}(:, :, 1) = this.velocityData{t_idx}(i, y_range, z_range, 2);
            this.velocityYZPlane{i}(:, :, 2) = this.velocityData{t_idx}(i, y_range, z_range, 3);
        end

        % Set cartesian coordinates
        [~, this.Z] = meshgrid(y_range, z_range);

        % Flip matricies (so we have x-dim by y-dim, strange Matlab
        % convention is to have it opposite when using meshgrid)
        this.Z = this.Z';
    end
