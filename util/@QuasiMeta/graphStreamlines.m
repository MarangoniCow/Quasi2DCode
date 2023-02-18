function fig = graphStreamlines(this, POIvalIDX)
            % GRAPHSTREAMLINES(this, POIvalIDX)
            %
            % Graph the streamlines with the coefficients of the associated POIval, accessed by index

            if nargin < 2
                this.QuasiDataObj.VelData.graphStreamlines;
            else
                this.assignCoefficients(POIvalIDX);
                fig = this.QuasiDataObj.graphStreamlines(this.ApproxType);
            end
end