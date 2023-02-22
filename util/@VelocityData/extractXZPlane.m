function extractXZPlane(this, t_idx, y_idx, x_range, z_range)
        % extractPlane(this, t_idx, z_idx)
        %
        % Extracts the XZ plane perpendicular to the XY plane.
        % Should only be run if velocityPlane has already been extracted.
        % 
        % INPUTS
        %   this        - VelocityData object
        %   t_idx       - Point of time of interest
        %   y_idx       - Y points of interest
        %   x_range     - (opt) Range of x
        %   z_range     - (opt) Range of z
        % OUTPUTS
        %   Writes output to this.velocityXZPlane

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
            x_range = 1:this.systemSize(1);
            z_range = 1:this.systemSize(3);
        else
            % NEED BETTER ERROR CHECKING HERE
        end
        

        
        % Initialise data types
        for i = 1:length(y_idx)
            this.velocityXZPlane{i} = zeros(length(x_range), length(z_range));
            
            % Extract velocity data from LudwigData datatype 
            this.velocityXZPlane{i}(:, :, 1) = this.velocityData{t_idx}(x_range, i, z_idx, 1);
            this.velocityXZPlane{i}(:, :, 2) = this.velocityData{t_idx}(x_range, i, z_idx, 3);
        end

        % Set cartesian coordinates
        [~, this.Z] = meshgrid(x_range, z_range);

        % Flip matricies (so we have x-dim by y-dim, strange Matlab
        % convention is to have it opposite when using meshgrid)
        this.Z = this.Z';
    end
