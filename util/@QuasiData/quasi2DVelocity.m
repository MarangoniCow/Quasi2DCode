function [ux, uy] = quasi2DVelocity(this, B, r, theta, bool)
    % quasi2DVelocity -- Returns the ux, uy velocity field for an approximation

    if nargin < 5
        bool = false;

        if nargin < 4
            r = this.VelData.R;
            theta = this.VelData.Th;
            if nargin < 3
                B = this.Coeff;
            end
        end
    end
        

    % Local variables
    lambda = this.lambda;
    U = this.colloidVelocity;
    a = this.VelData.colloidRadius;

    ur = 0;
    ut = 0;
    
    % Run over solve order
    for n = 1:length(B)
    
        % Shorthand notations
        kappa   = besselk(n, a./lambda);
        BK      = besselk(n, r./lambda)./kappa;
        BKD     = -1./lambda.*(besselk(n - 1, r./lambda) + n*lambda./r.*besselk(n, r./lambda))./kappa;
    
        % Add U terms
        if n == 1
            ur = ur + U.*a.*cos(theta)./r.*BK;
            ut = ut - U.*a.*sin(theta).*BKD;
        end
        
        % Radial and angular velocities
        ur = ur + n*B(n).*cos(n.*theta)./r.*(r.^(-n) - a.^-(n).*BK);
        ut = ut + B(n).*sin(n*theta).*(n.*r.^(-n -1) + a.^(-n).*BKD);              
    end

    % Return the transformed values
    ux =    ur.*cos(theta) - ut.*sin(theta);
    uy =    ur.*sin(theta) + ut.*cos(theta);

    if bool
        % Local variables
        X = this.VelData.X;
        Y = this.VelData.Y;
    
        x0 = this.VelData.x0;
        y0 = this.VelData.y0;
    
        L = this.VelData.systemSize(1);
        W = this.VelData.systemSize(2);
    
        % Reflection in +ve-y plane
        Xa = X - x0; Ya = Y - y0 - W;
        [Tha, Ra] = cart2pol(Xa, Ya);
    
        % Reflection in -ve-y plane
        Xb = X - x0; Yb = Y - y0 + W;
        [Thb, Rb] = cart2pol(Xb, Yb);
    
        % Reflection in +ve-x plane
        Xc = X - x0 - L; Yc = Y - y0;
        [Thc, Rc] = cart2pol(Xc, Yc);
    
        % Reflection in -ve-x plane
        Xd = X - x0 + L; Yd = Y - y0;
        [Thd, Rd] = cart2pol(Xd, Yd);

        [uxa, uya] = this.quasi2DVelocity(B, Ra, Tha);
        [uxb, uyb] = this.quasi2DVelocity(B, Rb, Thb);
        [uxc, uyc] = this.quasi2DVelocity(B, Rc, Thc); 
        [uxd, uyd] = this.quasi2DVelocity(B, Rd, Thd);

        ux = ux + uxa + uxb + uxc + uxd;
        uy = uy + uya + uyb + uyc + uyd;
        

        % REPEAT FOR DIAGONALS
         % Reflection in +ve-y plane 
        Xa = X - x0 - L; Ya = Y - y0 - W;
        [Tha, Ra] = cart2pol(Xa, Ya);
    
        % Reflection in -ve-y plane
        Xb = X - x0 - L; Yb = Y - y0 + W;
        [Thb, Rb] = cart2pol(Xb, Yb);
    
        % Reflection in +ve-x plane
        Xc = X - x0 + L; Yc = Y - y0 - W;
        [Thc, Rc] = cart2pol(Xc, Yc);
    
        % Reflection in -ve-x plane
        Xd = X - x0 + L; Yd = Y - y0 + W;
        [Thd, Rd] = cart2pol(Xd, Yd);

        [uxa, uya] = this.quasi2DVelocity(B, Ra, Tha);
        [uxb, uyb] = this.quasi2DVelocity(B, Rb, Thb);
        [uxc, uyc] = this.quasi2DVelocity(B, Rc, Thc); 
        [uxd, uyd] = this.quasi2DVelocity(B, Rd, Thd);

        ux = ux + uxa + uxb + uxc + uxd;
        uy = uy + uya + uyb + uyc + uyd;
    end
end