
function psi = nearStreamfunction(this, R, Th)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % nearStreamFunction(R, Th)
            %
            % Returns the analytically defined stream function at R and Th
            %
            % INPUTS:
            %   - R                 Polar-coordinate for radius
            %   - Th                Polar-coordinate for theta
            %
            % OUTPUTS:
            %   - psi               Analytically-defined stream function

            b1 = this.B_near(1);
            b2 = this.B_near(2);
            a = this.colloidRadius;
            U = this.colloidVelocity;
            [rows, cols] = size(R);
            psi = zeros(size(R));

            kappa1 = besselk(1, a./this.lambda);
            kappa2 = besselk(2, a./this.lambda);
                    
            for i = 1:rows
                for j = 1:cols
            
                    r = R(i, j);
                    theta = Th(i, j);
    
                    Kt1 = besselk(1, r./this.lambda)./kappa1;
                    Kt2 = besselk(2, r./this.lambda)./kappa2;
                    
                    if(r < a)
                        psi(i, j) = 0;
                    else
                        psi(i, j) = r.^-1.*b1.*cos(theta).*(r^-1 - a.^-1.*Kt1) + U.*a.*sin(theta).*Kt1 + ...
                            b2.*sin(2.*theta).*(r^-2 - a.^-2.*Kt2);
                    end
                end
            end

        end