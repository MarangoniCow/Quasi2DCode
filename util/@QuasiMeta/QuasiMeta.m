classdef QuasiMeta < handle
    % QuasiMeta: Meta-info class to encapsulate QuasiData methods

    properties (Access = public)
        ApproxType
        seriesID
        QuasiObjFolderStr
        POI
        N
        POIval
    end

    properties
        Coefficients
        Fminsum
    end

    methods
        function this = QuasiMeta(QuasiDataObj, ApproxType, POI)
            % Fetch QuasiDataObj information
            this.ApproxType = ApproxType;
            this.seriesID   = QuasiDataObj.VelData.seriesID;
            this.POI        = POI;
            this.POIval     = [];
            
        end

    end


    methods
        function appendCoefficientStruct(this, CoeffStruct, POIval)

            % Append new POIval number
            this.POIval = [this.POIval, POIval];

            % Set N
            this.N      = length(this.POIval);

            % Append coefficients
            if isempty(this.Coefficients)
                this.Coefficients = cell(1, 1);
                this.Coefficients{1} = CoeffStruct.Coefficients;
            else
                this.Coefficients{this.N} = CoeffStruct.Coefficients;
            end

            % Append sum
            this.Fminsum        = [this.Fminsum, CoeffStruct.Fminsum];


        end


        function graphCoefficients(this, order)

            load(this.fetchLoadStr);
            a = QuasiObj.colloidRadius;
            
            C = zeros(1, this.N);

            factor = a^(order - 1);
                       

            for i = 1:length(C)
                C(i) = this.Coefficients{i}(order)/factor;
            end

            plot(C, 'DisplayName', ['Order ', num2str(order)]);

            xlabel(this.POI);
            ylabel(['Coefficients order $\mathcal{O}(', num2str(order), ')$'], 'interpreter', 'latex');

            
        end

        function graphFminsum(this)
            
            U = this.avgSimulationVelocity;

            plot(this.Fminsum./U, 'DisplayName', this.seriesID);

            xlabel(this.POI);
            ylabel('Fminsum');


        end

        function graphStreamlines(this, idx)

            load(this.fetchLoadStr);

            if nargin > 1
                this.assignCoefficients(QuasiObj, idx);
                QuasiObj.graphStreamlines(this.ApproxType);
            else
                QuasiObj.VelData.graphStreamlines;
            end


        end

        function graphStreamlineModes(this, POIval, order)
            load(this.fetchLoadStr);

            Coeffs = this.Coefficients{POIval};
            r = length(Coeffs);

            idxList = 1:r;
            
            
            if order ~= 0
                idxList(order) = [];
                QuasiObj.colloidVelocity = 0;
            end

            Coeffs(idxList) = 0;

            QuasiObj.(['Coeff', this.ApproxType]) = Coeffs;

            QuasiObj.graphStreamlines(this.ApproxType);

                    
                    

            



        end

        function graphResidues(this, idx)

            load(this.fetchLoadStr);

            this.assignCoefficients(QuasiObj, idx);
            QuasiObj.graphResidues(this.ApproxType);


        end

        function Vbar = avgSimulationVelocity(this)

            load(this.fetchLoadStr)

            Vs = QuasiObj.VelData.velocityPlaneCartesian(:);
            Vbar = 0;

            for i = 1:length(Vs)
                Vbar = Vbar + Vs(i);
            end
            Vbar = Vbar/length(Vs);


        end

        function str = fetchLoadStr(this)
            str = ['/Development/repos/Quasi2DCode/Data/', this.seriesID];          
                
        end

        function assignCoefficients(this, QuasiObj, order)
            
            CoeffStr = ['Coeff', this.ApproxType];
            QuasiObj.(CoeffStr) = this.Coefficients{order};


        end


    end
end