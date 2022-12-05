
function [ur, ut] = nearVelocityField(this, R, Th)


    if nargin == 1
        R = this.VelData.R;
        Th = this.VelData.Th;
    end

    % Local helper variables
    U = this.colloidVelocity;
    a = this.colloidRadius;
    B = this.B_near;


    kappa1 = besselk(1, a./this.lambda);
    kappa2 = besselk(2, a./this.lambda);
            
    Kt1 = besselk(1, R./this.lambda)./kappa1;
    Kt2 = besselk(2, R./this.lambda)./kappa2;
    
    Kd1 = -1./(this.lambda*kappa1).*(besselk(0, R./this.lambda) + R./this.lambda.*besselk(1, R./this.lambda));
    Kd2 = -1./(this.lambda*kappa2).*(besselk(1, R./this.lambda) + 2.*R./this.lambda.*besselk(2, R./this.lambda));
                
    % Define Radial component
    ur = R.^-1.*B(1).*cos(Th).*(R.^-1 - a.^-1.*Kt1) + R.^-1.*U.*a.*cos(Th).*Kt1 + ...
            2.*B(2).*cos(2.*Th).*(R.^-2 - a.^-2.*Kt2);
    
    % Define angulaR component
    ut = B(1).*sin(Th).*(-R.^-2 - a.^-1.*Kd1) + U.*a.*sin(Th).*Kd1 + ...
            B(2).*sin(2.*Th).*(-2.*R.^-3 - a.^-2.*Kd2);


    %  Set velocity to zero where the colloid is
    Vr = this.VelData.velocityPlanePolar(:, :, 1);
    
    % Find colloid location
    idxlist = find(~Vr);
    ur(idxlist) = 0;
    ut(idxlist) = 0;
    
    
end