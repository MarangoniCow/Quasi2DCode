classdef QuasiMeta
    % QuasiMeta: Meta-info class to encapsulate QuasiData methods

    properties (SetAccess = protected)
        N
        POIval
    end

    properties (Access = public)
        ApproxType
        seriesID
        QuasiObjFolderStr
        POI
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
        end

    end


    methods
        function appendCoefficientStruct(CoeffStruct, newPOIval)
            this.POIval = [this.POIval, newPOIval];
            this.N = length(this.POIval);
            this.Coefficients = [this.Coefficients, CoeffStruct.Coefficients];
            this.Fminsum = [this.Fminsum, CoeffStruct.Fminsum];
        end

        function graphCoefficients

            [r, ~] = size(this.Coefficients);
            for i = 1:r
                figure
                plot(this.Coefficients(i, :));

                xlabel(this.POI);
                ylabel('Coefficients');
            end

            
        end

        function graphFminsum

            plot(this.Fminsum);

            xlabel(this.POI);
            ylabel('Fminsum');


        end

        function graphStreamlines(idx)

            load(this.QuasiObjFolderStr);
            QuasiObj.(this.ApproxType) = this.Coefficients(idx);
            QuasiObj.graphStreamlines(this.ApproxType);


        end
    end
end