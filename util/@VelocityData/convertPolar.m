function convertPolar(this, x0, y0)
    % converPolar(this, x0, y0)
    %
    % Converts this.velocityPlaneCartesian to a polar velocity
    % description centered around x0, y0. The velocity cartesian
    % plane must be extracted first before running convertPolar.
    %
    % INPUTS
    %   x0      - x-coordinate for new origin
    %   y0      - y-coordinate for new origin
    % OUTPUTS
    %   Writes to this.velocityPlanePolar

    % Check for plane existence
    try
        this.checkForCartesianPlane;
    catch
        error('Plane must be extracted first');
    end

    % Set default x0/y0
    if nargin == 1
        x0 = this.colloidDisp(1, this.timeStep);
        y0 = this.colloidDisp(2, this.timeStep);
    end

    this.x0 = x0;
    this.y0 = y0;          

    % Fetch velocity plane (cartersian) and initialise polar
    % version
    [row, col, ~] = size(this.velocityPlaneCartesian);
    this.velocityPlanePolar = zeros(row, col, 2);

    % Define coordinate transform
    Xd = this.X - x0; Yd = this.Y - y0;

    % Transform cartesian to polar coordinates (but still on a
    % cartesian grid)
    [this.Th, this.R] = cart2pol(Xd, Yd);

    % Fetch local fluid velocity
    Ux = this.velocityPlaneCartesian(:, :, 1);
    Uy = this.velocityPlaneCartesian(:, :, 2);

    % Update r and theta velocities
    Ur = (Xd.*Ux + Yd.*Uy)./this.R;
    Ut = (Xd.*Uy - Yd.*Ux)./this.R;

    % Assignt to velocityPlanePolar
    this.velocityPlanePolar(:, :, 1) = Ur;
    this.velocityPlanePolar(:, :, 2) = Ut;
end