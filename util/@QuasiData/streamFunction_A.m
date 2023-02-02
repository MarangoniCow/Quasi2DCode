function psi = streamFunction_A(this, R, Th)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555
            % streamFunction_A(R, Th)
            %
            % Returns the analytically defined stream function at R and Th
            %
            % INPUTS:
            %   - R                 Polar-coordinate for radius
            %   - Th                Polar-coordinate for theta
            %
            % OUTPUTS:
            %   - psi               Analytically-defined stream function

            b1 = this.CoeffA(1);
            b2 = this.CoeffA(2);
            c1 = this.CoeffA(3);
            c2 = this.CoeffA(4);
            a = this.colloidRadius;
            
            [rows, cols] = size(R);
            psi = zeros(size(R));
    
            for i = 1:rows
                for j = 1:cols
            
                    r = R(i, j);
                    theta = Th(i, j);
                    
                    if(r < a)
                        psi(i, j) = 0;
                    else
                        psi(i, j) = b1.*r.^-1.*sin(theta) + b2.*r.^-2.*sin(2.*theta) + ...
                            c1.*besselk(1, r./this.lambda).*sin(theta) + c2.*besselk(2, r./this.lambda).*sin(2*theta);
                    end
                end
            end
        end