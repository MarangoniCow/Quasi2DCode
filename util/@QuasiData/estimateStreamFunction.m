

function CoeffStruct = estimateStreamFunction(this, varargin)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % estimateStreamfunction(this)
        %
        % Calculates coefficients for the Quasi2D analytic streamfunction
        % -- the approximation for the 2D flow generated by a swimmer in
        % confinement.
        %
        % There are multiple different approximations for the
        % streamfunction. The approximation desired can be specified by
        % providing the 'approximationType' argument with the values 'A' or 'B'.
        %
        % The approximations are defined up to order 4, and the solve order
        % can be set by 'solveOrder'.
        %
        % When solving for the streamfunction, points close to the swimmer
        % may not satisfy the analytical expression. Consequently, we can
        % use the argument 'exclusionRadius' to define the exclusion radius
        % about the swimmer. This defaults to the colloid radius.
        %
        % INPUTS
        %   - approximationType         Function to be fitted, 'A' or 'B'
        %   - solveOrder                Maximum (up to 4) order of function
        %   - errorTol                  Error tolerance for fitting
        %   - exclusionRadius           Radius of excluded points around
        %                               the swimmer, from 0 to the channel
        %                               width.
        %
        % OUTPUTS
        %   - CoeffStruct               Solution struct with the following:
        %                               ApproximationType
        %                               Coefficients
        %                               ExclusionRadius
        %                               Fminstats
        %                               Fminsum





        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                       PARSE INPUTS                              %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        p = inputParser;

        
        % Approximation type
        approximationDefault = 'B';
        approximationOptions = {'A', 'B'};
        approximationValidation = @(x) any(strcmp(x, approximationOptions));
        p.addOptional('approximationType', approximationDefault, approximationValidation);

        % Exclusion radius
        exclusionDefault = this.colloidRadius;
        exclusionMax = floor(0.5*(this.VelData.systemSize(2) - this.colloidRadius));
        exclusionValidation = @(x) isnumeric(x) && x >= 0 && x <= exclusionMax;
        p.addOptional('exclusionRadius', exclusionDefault, exclusionValidation);

        % Solve order
        solveOrderDefault = 2;
        solveOrderMax = 4;
        solveOrderValidation = @(x) isPositiveIntegerValuedNumeric(x) && x > 0 && x <= solveOrderMax;
        p.addOptional('solveOrder', solveOrderDefault, solveOrderValidation);

        % Error tolerance
        errorTolDefault = 1e-4;
        errorTolValidation = @(x) isnumeric(x) && x > 0;
        p.addOptional('errorTol', errorTolDefault, errorTolValidation);

        parse(p, varargin{:})
        
        CoeffStruct = struct('ApproximationType', p.Results.approximationType, ...
                            'Coefficients', [], 'Fminstats', [], 'Fminsum', [], ...
                            'ExclusionRadius', p.Results.exclusionRadius);
    

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                   LOCALLY-SCOPED VARIABLES                      %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        
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

        


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                   GENERATE EXCLUSION RADIUS                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

        [Xc, Yc] = generateRadialXYPoints(x0, y0, a + p.Results.exclusionRadius);
        
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
        N = length(X);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                       SET-UP FMINSEARCH                         %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

        % Switch between orders
        switch p.Results.solveOrder
            case 1
                guessA  = [1, 1];
                guessB  = [1];
            case 2
                guessA  = [1, 100, 1, 100];
                guessB  = [1, 100];
            case 3
                guessA  = [1, 100, 10, 1, 100, 10];
                guessB  = [1, 100, 10];
            case 4
                guessA  = [1, 100, 10, 0.1, 1, 100, 10, 0.1];
                guessB  = [1, 100, 10, 0.1];
        end
        

        % fminsearch options
        options = optimset('MaxFunEvals', 300*length(guessA), 'MaxIter', 300*length(guessA));
        
        % Run fminsearch
        switch p.Results.approximationType
            case 'A'
                [this.CoeffA, ~, ~, this.statsA]  = fminsearch(@Q2D_Approximation_A, guessA, options);
                CoeffStruct.Coefficients = this.CoeffA;
                CoeffStruct.Fminstats = this.statsA;
                CoeffStruct.Fminsum = Q2D_Approximation_A(this.CoeffA);
            case 'B'
                [this.CoeffB, ~, ~, this.statsB] = fminsearch(@Q2D_Approximation_B, guessB, options);
                CoeffStruct.Coefficients = this.CoeffB;
                CoeffStruct.Fminstats = this.statsB;
                CoeffStruct.Fminsum = Q2D_Approximation_A(this.CoeffB);
        end

        
        
        
        %%%%%%%%%%%%%%%%%% ANALYTICALLY DEFINED STREAM FUNCTIONS %%%%%%%%%%%%%%%%%%
            
        function f = Q2D_Approximation_A(B)
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
                    B3 = 0;
                    B4 = 0;
                    C1 = B(2);
                    C2 = 0;
                    C3 = 0;
                    C4 = 0;
                case 4
                    B1 = B(1);
                    B2 = B(2);
                    B3 = 0;
                    B4 = 0;
                    C1 = B(3);
                    C2 = B(4);
                    C3 = 0;
                    C4 = 0;
                case 6
                    B1 = B(1);
                    B2 = B(2);
                    B3 = B(3);
                    B4 = 0;
                    C1 = B(4);
                    C2 = B(5);
                    C3 = B(6);
                    C4 = 0;
                case 8
                    B1 = B(1);
                    B2 = B(2);
                    B3 = B(3);
                    B4 = B(4)
                    C1 = B(5);
                    C2 = B(6);
                    C3 = B(7);
                    C4 = B(8);

                otherwise
                    error('Undetermined number of coefficients')
            end
            

            lambda = this.lambda;
            
            
            f = 0;

            for idx = 1:N
            
                r = R(idx);
                theta = Th(idx);

                

                % Define besselk'_i(r/lambda)
                BKD1 = -1./lambda.*(besselk(0, r./lambda) + lambda./r.*besselk(1, r./lambda));
                BKD2 = -1./lambda.*(besselk(1, r./lambda) + 2.*lambda./r.*besselk(2, r./lambda));
                BKD3 = -1./lambda.*(besselk(2, r./lambda) + 3.*lambda./r.*besselk(3, r./lambda));
                BKD4 = -1./lambda.*(besselk(3, r./lambda) + 4.*lambda./r.*besselk(4, r./lambda));
            
                % Define radial component
                ur =    1*B1.*r.^-2.*cos(theta) + ...
                        2*B2.*r.^-3.*cos(2*theta) + ...
                        3*B3.*r.^-4.*cos(3*theta) + ...
                        4*B4.*r.^-5.*cos(4*theta) + ...
                        1*C1./r.*cos(1*theta).*besselk(1, r./this.lambda) + ...
                        2*C2./r.*cos(2*theta).*besselk(2, r./this.lambda) + ...
                        3*C3./r.*cos(3*theta).*besselk(3, r./this.lambda) + ...
                        4*C4./r.*cos(4*theta).*besselk(4, r./this.lambda);
                
                % Define angular component
                ut =    1*B1.*r.^-2.*sin(1*theta) + ...
                        2*B2.*r.^-3.*sin(2*theta) + ... 
                        3*B3.*r.^-4.*sin(3*theta) + ... 
                        4*B4.*r.^-5.*sin(4*theta) + ... 
                        -C1.*sin(1*theta)./lambda.*BKD1 + ...
                        -C2.*sin(2*theta)./lambda.*BKD2 + ...
                        -C3.*sin(3*theta)./lambda.*BKD3 + ...
                        -C4.*sin(4*theta)./lambda.*BKD4;
                
                % Summation
                f = f + sqrt((Vr(idx) - ur).^2 + (Vt(idx) - ut).^2);
                f = f./N;
            end
        end
    
        function f = Q2D_Approximation_B(B)
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
                    B4 = B(4);

                otherwise
                    error('Undetermined number of coefficients')
            end


            lambda = this.lambda;
            
            kappa1 = besselk(1, a./this.lambda);
            kappa2 = besselk(2, a./this.lambda);
            kappa3 = besselk(3, a./this.lambda);
            kappa4 = besselk(4, a./this.lambda);

            f = 0;
            
            
            for idx = 1:N
            
                r = R(idx);
                theta = Th(idx);
                
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
                ur =    1*B1.*cos(1*theta)./r.*(r.^-1 - a.^-1.*BK1) + U.*a.*cos(theta)./r.*BK1 + ...
                        2*B2.*cos(2*theta)./r.*(r.^-2 - a.^-2.*BK2) + ...
                        3*B2.*cos(3*theta)./r.*(r.^-3 - a.^-3.*BK3) + ...
                        4*B4.*cos(4*theta)./r.*(r.^-4 - a.^-4.*BK4);


                % Define angular component
                ut =    B1.*sin(1*theta).*(1.*r^-2 + a.^-1.*BKD1) - U.*a.*sin(theta).*BKD1 + ...
                        B2.*sin(2*theta).*(2.*r^-3 + a.^-2.*BKD2) + ...
                        B3.*sin(3*theta).*(2.*r^-4 + a.^-3.*BKD3) + ...
                        B4.*sin(4*theta).*(4.*r^-5 + a.^-4.*BKD4);
            
                f = f + (Vr(idx) - ur).^2 + (Vt(idx) - ut).^2;
                f = f./N;
            end
        end
end