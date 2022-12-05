
function [ur, ut] = farVelocityField(this, R, Th)


    if nargin == 1
        R = this.VelData.R;
        Th = this.VelData.Th;
    end

    % Local helper variables
    B = this.B_far;


    % Define radial component
    ur = B(1).*R.^-2.*cos(Th) + 2*B(2).*R.^-3.*cos(2*Th) + ... 
            B(3)./R.*besselk(1, R./this.lambda).*cos(Th) + 2.*B(4)./R.*besselk(2, R./this.lambda).*cos(2*Th);
                
    % Define angular component
    ut = B(1).*R.^-2.*sin(Th) + B(2).*R.^-3.*sin(2*Th) + ... 
            B(3)./R.*(besselk(0, R./this.lambda) + R./this.lambda.*besselk(1, R./this.lambda)).*sin(Th) + ...
            B(4)./R.*(besselk(1, R./this.lambda) + 2*R./this.lambda.*besselk(2, R./this.lambda)).*sin(2*Th);


    %  Set velocity to zero where the colloid is
    Vr = this.VelData.velocityPlanePolar(:, :, 1);
    
    % Find colloid location
    idxlist = find(~Vr);
    ur(idxlist) = 0;
    ut(idxlist) = 0;
    
end