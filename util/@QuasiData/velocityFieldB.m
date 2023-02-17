
function [ur, ut] = velocityFieldB(this)

    r = this.VelData.R;
    theta = this.VelData.Th;

    % Local helper variables
    U = this.colloidVelocity;
    a = this.colloidRadius;
    lambda = this.lambda;
    B = this.CoeffB;
    solveOrder = length(B) - 1;
    
    % Define ur and ut: add simulation drift velocity if requested
    ur = B(end).*cos(theta);
    ut = -B(end).*sin(theta);

    % Run over solve order
    for n = 1:solveOrder
    
        % Shorthand notations
        kappa   = besselk(n, a./lambda);
        BK      = besselk(n, r./lambda)./kappa;
        BKD     = -1./lambda.*(besselk(n - 1, r./lambda) + n*lambda./r.*besselk(n, r./lambda))./kappa;
    
%          Add U terms
        if n == 1
            ur = ur + U.*a.*cos(theta)./r.*BK;
            ut = ur - U.*a.*sin(theta).*BKD;
        end
        
        % Radial and angular velocities
        ur = ur + n*B(n).*cos(n.*theta)./r.*(r.^(-n) - a.^-(n).*BK);
        ut = ut + B(n).*sin(n*theta).*(n.*r.^(-n -1) + a.^(-n).*BKD);
    end
            


    %  Set velocity to zero where the colloid is
    Vr = this.VelData.velocityPlanePolar(:, :, 1);
    
    % Find colloid location
    idxlist = find(~Vr);
    ur(idxlist) = 0;
    ut(idxlist) = 0;
    
    
end