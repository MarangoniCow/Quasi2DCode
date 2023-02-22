function extractXYPlane(this, t_idx, z_idx, x_range, y_range)
        % extractPlane(this, t_idx, z_idx)
        %
        % Extracts a plane from the cartesian velocity data at a given
        % height and point in time of the simulation.
        % 
        % INPUTS
        %   this        - VelocityData object
        %   t_idx       - Point of time of interest
        %   z_idx       - Plane height of interest
        %   x_range     - (opt) Range of x
        %   y_range     - (opt) Range of y
        % OUTPUTS
        %   Writes output to this.velocityPlaneCartesian

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
            y_range = 1:this.systemSize(2);
        else
            % NEED BETTER ERROR CHECKING HERE
        end
        

        
        % Initialise data types
        this.velocityPlaneCartesian = zeros(length(x_range), length(y_range));
        
        % Extract velocity data from LudwigData datatype 
        this.velocityPlaneCartesian(:, :, 1) = this.velocityData{t_idx}(x_range, y_range, z_idx, 1);
        this.velocityPlaneCartesian(:, :, 2) = this.velocityData{t_idx}(x_range, y_range, z_idx, 2);

        % Set cartesian coordinates
        [this.X, this.Y] = meshgrid(x_range, y_range);

        % Flip matricies (so we have x-dim by y-dim, strange Matlab
        % convention is to have it opposite when using meshgrid)
        this.X = this.X';
        this.Y = this.Y';

        % Set internals
        this.timeStep = t_idx;
        this.extractHeight = z_idx;
    end
