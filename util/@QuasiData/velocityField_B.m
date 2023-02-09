
function [ur, ut] = velocityField_B(this)

    r = this.VelData.R;
    theta = this.VelData.Th;

    % Local helper variables
    U = this.colloidVelocity;
    a = this.colloidRadius;
    lambda = this.lambda;
    
    B = this.CoeffB;
    switch length(B)
                case 1
                    B1 = B(1);
                    B2 = 0;
                    B3 = 0;
                    B4 = 0;
                case 2
                    B1 = B(1);
                    B2 = B(2);
                    B3 = 0;
                    B4 = 0;
                case 3
                    B1 = B(1);
                    B2 = B(2);
                    B3 = B(3);
                    B4 = 0;
                case 4
                    B1 = B(1);
                    B2 = B(2);
                    B3 = B(3);
                    B4 = B(4);

                otherwise
                    error('Undetermined number of coefficients')
    end



    kappa1 = besselk(1, a./this.lambda);
    kappa2 = besselk(2, a./this.lambda);
    kappa3 = besselk(3, a./this.lambda);
    kappa4 = besselk(4, a./this.lambda);
            
    % Derivatives
    BKD1 =  -1./lambda.*(besselk(0, r./lambda) + 1*lambda./r.*besselk(1, r./lambda))./kappa1;
    BKD2 =  -1./lambda.*(besselk(1, r./lambda) + 2*lambda./r.*besselk(2, r./lambda))./kappa2;
    BKD3 =  -1./lambda.*(besselk(2, r./lambda) + 3*lambda./r.*besselk(3, r./lambda))./kappa3;
    BKD4 =  -1./lambda.*(besselk(3, r./lambda) + 4*lambda./r.*besselk(4, r./lambda))./kappa4;
    
    BK1 =   besselk(1, r./this.lambda)./kappa1;
    BK2 =   besselk(2, r./this.lambda)./kappa2;
    BK3 =   besselk(3, r./this.lambda)./kappa3;
    BK4 =   besselk(4, r./this.lambda)./kappa4;


     % Define radial component
    ur =    1*B1.*cos(1.*theta)./r.*(r.^-1 - a.^-1.*BK1) + U.*a.*cos(theta)./r.*BK1 + ...
            2*B2.*cos(2.*theta)./r.*(r.^-2 - a.^-2.*BK2) + ...
            3*B2.*cos(3.*theta)./r.*(r.^-3 - a.^-3.*BK3) + ...
            4*B4.*cos(4.*theta)./r.*(r.^-4 - a.^-4.*BK4);


    % Define angular component
    ut =    B1.*sin(1*theta).*(1.*r.^-2 + a.^-1.*BKD1) - U.*a.*sin(theta).*BKD1 + ...
            B2.*sin(2*theta).*(2.*r.^-3 + a.^-2.*BKD2) + ...
            B3.*sin(3*theta).*(2.*r.^-4 + a.^-3.*BKD3) + ...
            B4.*sin(4*theta).*(4.*r.^-5 + a.^-4.*BKD4);

    %  Set velocity to zero where the colloid is
    Vr = this.VelData.velocityPlanePolar(:, :, 1);
    
    % Find colloid location
    idxlist = find(~Vr);
    ur(idxlist) = 0;
    ut(idxlist) = 0;
    
    
end