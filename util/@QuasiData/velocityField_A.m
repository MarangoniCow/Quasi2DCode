
function [ur, ut] = velocityField_A(this, r, theta)


    if nargin == 1
        r = this.VelData.R;
        theta = this.VelData.Th;
    end

    % Local helper variables
    B = this.CoeffA;
    switch length(B)
        case 2
            B1 = B(1);
            B2 = 0;
            B4 = 0;
            C1 = B(2);
            C2 = 0;
            C4 = 0;
        case 4
            B1 = B(1);
            B2 = B(2);
            B4 = 0;
            C1 = B(3);
            C2 = B(4);
            C4 = 0;
        case 6
            B1 = B(1);
            B2 = B(2);
            B4 = B(3);
            C1 = B(4);
            C2 = B(5);
            C4 = B(6);

        otherwise
            error('Undetermined number of inputs')
    end
    lambda = this.lambda;

    



    % Define besselk'_i(r/lambda)
    BKD1 = -1./lambda.*(besselk(0, r./lambda) + lambda./r.*besselk(1, r./lambda));
    BKD2 = -1./lambda.*(besselk(1, r./lambda) + 2.*lambda./r.*besselk(2, r./lambda));
    BKD4 = -1./lambda.*(besselk(3, r./lambda) + 4.*lambda./r.*besselk(4, r./lambda));

    % Define radial component
    ur =    1*B1.*r.^-2.*cos(theta) + ...
            2*B2.*r.^-3.*cos(2*theta) + ...
            4*B4.*r.^-5.*cos(4*theta) + ...
            1*C1./r.*cos(1*theta).*besselk(1, r./this.lambda) + ...
            2*C2./r.*cos(2*theta).*besselk(2, r./this.lambda) + ...
            4*C4./r.*cos(4*theta).*besselk(4, r./this.lambda);
    
    % Define angular component
    ut =    1*B1.*r.^-2.*sin(1*theta) + ...
            2*B2.*r.^-3.*sin(2*theta) + ... 
            4*B4.*r.^-5.*sin(4*theta) + ... 
            -C1.*sin(1*theta)./lambda.*BKD1 + ...
            -C2.*sin(2*theta)./lambda.*BKD2 + ...
            -C4.*sin(4*theta)./lambda.*BKD4;


    %  Set velocity to zero where the colloid is
    Vr = this.VelData.velocityPlanePolar(:, :, 1);
    
    % Find colloid location
    idxlist = find(~Vr);
    ur(idxlist) = 0;
    ut(idxlist) = 0;
    
end