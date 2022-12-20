

function estimateStreamFunction(this, solve_order)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555
        % estimateNearStreamfunction(this)
        %
        % Calculates the coefficients b1, b2, b4, c1, c2, c4 for the Quasi-2D analytical
        % stream function -- the approximation for the 2D flow generated by a
        % swimmer in confinement.
        %
        % INPUTS:
        %   - this                  QuasiData instance
        %   - solve_order           Optional argument for solve order
        %
        % OUTPUTS:
        %   - B                     Coefficients for the analytical approximation,
        %                           where b1 = B(1), b2 = B(2), c1 = B(3), c2 =
        %                           B(4);
        
    
        % Check VelData has been correctly initialised
        validateattributes(this.VelData, {'VelocityData'}, {});
        this.VelData.checkForPolarPlane;

        validorders = {'1', '2', '4'};
        ordererror = ['1, ', '2, ', '4'];

        % Validate solver order
        if nargin == 1
            solve_order = 4;
        elseif nargin < 3 && ~any(strcmp(num2str(solve_order), validorders))
           error(['Invalid order requested, valid orders are ', ordererror]);
        end

        this.B_far = [];
        this.B_near = [];
        
        % Fetch coordinate data
        X = this.VelData.X(:);
        Y = this.VelData.Y(:);
        R = this.VelData.R(:);
        Th = this.VelData.Th(:);
        
        % Fetch velocity data
        Vr = this.VelData.velocityPlanePolar(:, :, 1);
        Vt = this.VelData.velocityPlanePolar(:, :, 2);
        Vr = Vr(:);
        Vt = Vt(:);
        
        % Fetch parameters
        x0 = this.VelData.x0;
        y0 = this.VelData.y0;
        this.lambda = sqrt(this.VelData.systemSize(3)^2/12);
        
        % Generate list of points to exclude
        a = this.VelData.colloid_a;
        U = this.VelData.colloidVel(:, this.VelData.timeStep);
        U = sqrt(dot(U, U));

        this.colloidRadius = a;
        this.colloidVelocity = U;

        [Xc, Yc] = generateRadialXYPoints(x0, y0, a + 1);
        
        % Generate idx list of points
        idxList = [];

        % For each element in the excluded list of points...
        for i = 1:length(Xc)
            
            % ...if there's a corresponding matching point in the mesh, it
            % will need to be removed.
            for j = 1:length(X)
        
                if(Xc(i) == X(j) && Yc(i) == Y(j))
                    idxList = [idxList, j];
                    break;
                end
            end
        end
        
        % Delete colloidal points that shouldn't be use in parameter
        % matching (colloid radius + some buffer)
        X(idxList) = [];
        Y(idxList) = [];
        Vr(idxList) = [];
        Vt(idxList) = [];
        R(idxList) = [];
        Th(idxList) = [];


        % Switch between orders
        switch solve_order
            case 1
                far_guess   = [1, -0.1];
                near_guess  = [0.1];
            case 2
                far_guess   = [1, 10, -0.1, -0.1];
                near_guess  = [0.1, -0.1];
            case 4
                far_guess   = [1, 10, -0.1, -0.1, 0.01, 0.01];
                near_guess  = [0.1, -0.5, -0.5];
        end
        

        % fminsearch options
        options = optimset('MaxFunEvals', 300*length(far_guess), 'MaxIter', 300*length(far_guess));
        
        % Run fminsearch
        [this.B_far, ~, ~, this.stats_far]  = fminsearch(@Q2D_farfield, far_guess, options);
        [this.B_near, ~, ~, this.stats_near] = fminsearch(@Q2D_nearfield, near_guess, options);
        
        
        %%%%%%%%%%%%%%%%%% ANALYTICALLY DEFINED STREAM FUNCTIONS %%%%%%%%%%%%%%%%%%
            
        function f = Q2D_farfield(B)
            % INPUT PARAMETERS
            %   b1, b2, c1, c2          - Unknown constants to be solved for
            %   x0, y0                  - Swimmer/colloid center
            %   lambda                  - 'Screening length' parameter, should be set
            %                               to sqrt(h^2/2)
            %   x, y                    - Cartesian coordinates to be solved at
            
            % Local helper functions
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
                    error('Undetermined number of coefficients')
            end
            

            lambda = this.lambda;
            
            
            f = 0;
            
            for idx = 1:length(X)
            
                r = R(idx);
                theta = Th(idx);

                

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
                
                % Summation
                f = f + (Vr(idx) - ur).^2 + (Vt(idx) - ut).^2;
            end
        end
    
        function f = Q2D_nearfield(B)
            % INPUT PARAMETERS
            %   b1, b2, c1, c2          - Unknown constants to be solved for
            %   x0, y0                  - Swimmer/colloid center
            %   lambda                  - 'Screening length' parameter, should be set
            %                               to sqrt(h^2/2)
            %   x, y                    - Cartesian coordinates to be solved at
            

            switch length(B)
                case 1
                    B1 = B(1);
                    B2 = 0;
                    B4 = 0;
                case 2
                    B1 = B(1);
                    B2 = B(2);
                    B4 = 0;
                case 3
                    B1 = B(1);
                    B2 = B(2);
                    B4 = B(3);

                otherwise
                    error('Undetermined number of coefficients')
            end


            lambda = this.lambda;
            
            kappa1 = besselk(1, a./this.lambda);
            kappa2 = besselk(2, a./this.lambda);
            kappa4 = besselk(4, a./this.lambda);

            f = 0;
            
            
            for idx = 1:length(X)
            
                r = R(idx);
                theta = Th(idx);
                
                % Derivatives
                BKD1 =  -1./lambda.*(besselk(0, r./lambda) + 1*lambda./r.*besselk(1, r./lambda))./kappa1;
                BKD2 =  -1./lambda.*(besselk(1, r./lambda) + 2*lambda./r.*besselk(2, r./lambda))./kappa2;
                BKD4 =  -1./lambda.*(besselk(3, r./lambda) + 4*lambda./r.*besselk(4, r./lambda))./kappa4;
                
                BK1 =   besselk(1, r./this.lambda)./kappa1;
                BK2 =   besselk(2, r./this.lambda)./kappa2;
                BK4 =   besselk(4, r./this.lambda)./kappa4;
                
                % Define radial component
                ur =    1*B1.*cos(1*theta)./r.*(r.^-1 - a.^-1.*BK1) + U.*a.*cos(theta)./r.*BK1 + ...
                        2*B2.*cos(2*theta)./r.*(r.^-2 - a.^-2.*BK2) + ...
                        4*B4.*cos(4*theta)./r.*(r.^-4 - a.^-4.*BK4);


                % Define angular component
                ut =    B1.*sin(1*theta).*(1.*r^-2 + a.^-1.*BKD1) - U.*a.*sin(theta).*BKD1 + ...
                        B2.*sin(2*theta).*(2.*r^-3 + a.^-2.*BKD2) + ...
                        B4.*sin(4*theta).*(4.*r^-5 + a.^-4.*BKD4);
            
                f = f + (Vr(idx) - ur).^2 + (Vt(idx) - ut).^2;
            end
        end
end