%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ======================= CLASS: QUASIMETA ===============================
%
% QuasiMeta captures changes in QuasiData objects over some paramer of
% interest. For example, QuasiMeta can capture the changes in Fminsum or
% Coefficients as the exclusionRadius, solveOrder or errorTol options are
% iterated in QuasiData.estimateStreamFunction. 
%
% MEMBER VARIABELS
%   QuasiDataObj        - QuasiData is a handle class, so we can safely store a reference to the object in question here
%   ApproxType          - QuasiData can handle multiple different approximations, but QuasiMeta can only keep track of
%                         one these.
%   seriesID            - Repeated data from QuasiDataObj
%   POI                 - Parameter Of Interest: QuasiMeta can only track changes in Coefficients and Fminsum for one
%                           type of parameter. This quantity must be a string and correspond to a QuasiData parameter.
%   POIval              - POI value:    Value(s) corresponding to the POI.
%   N                   - Number of values.


classdef QuasiMeta < handle
   

    properties (Access = public)
        QuasiDataObj
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
            this.QuasiDataObj = QuasiDataObj;
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


        function fig = graphCoefficients(this, order)
            % GRAPHCOEFFICIENTS(this, order)
            %
            % Graph changes in coefficients over POIval. Coefficients are factorised into dimensions of velocity.

            % Local variable
            a = this.QuasiDataObj.colloidRadius;

            % Initialise coefficients and factor
            C = zeros(1, this.N);

            if nargin < 2
                orderList = 1:length(this.Coefficients{1});
            else
                orderList = order;
            end

            fig = figure;
            colormap spring

            for i = 1:length(orderList)
                order = orderList(i);

                % TO DO: Re-write order of coefficients, or make special case for correct factor for B0
                factor = a^(order - 1);
    
                % Fetch coefficients
                for j = 1:length(C)
                    C(j) = this.Coefficients{j}(order)/factor;
                end
                
                % TO DO: Re-write: Shift all coefficients up by one, so B0 becomes order 1 (numerically)
                DispStr = ['Order ', num2str(order)];
                plot(this.POIval, C, 'DisplayName', DispStr, 'LineWidth', PlotDefaults.std.LineWidth);
                hold on;               
            end

            hold off;

            % PLOTDEFAULTS: Must be added to path
            xlabel(this.POI, 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
            ylabel('Approximation Coefficients', 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
            legend('FontSize', PlotDefaults.std.FontSizeLeg);
            PlotDefaults.applySizes('std')
            PlotDefaults.setLatexDefault;
            grid on;

        end

        function fig = graphFminsum(this)
            % GRAPHFMINSUM(this)
            %
            % Graph Fminsum over POIval

            fig = figure;
            
            Vbar = this.QuasiDataObj.VelData.avgSimulationVelocity;

            plot(this.POIval, this.Fminsum./Vbar, 'LineWidth', PlotDefaults.std.LineWidth);

            % PLOTDEFAULTS: Must be added to path to work!
            xlabel(this.POI, 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
            ylabel('Fminsum', 'FontSize', PlotDefaults.std.FontSizeLab, 'Interpreter', 'latex');
            PlotDefaults.applySizes('std')
            PlotDefaults.setLatexDefault;
            grid on;
        end

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

        function fig = graphStreamlineModes(this, POIvalIDX, order)
            % GRAPHSTREAMLINEMODES(this, POIvalIDX, order)
            %
            % Graph the streamline modes individually

            % Check validity of order
            order = int16(order);
            validateattributes(order, {'int16'}, {'positive'})

            % Fetch coefficients
            M = length(this.Coefficients{1});
            Coeff = this.Coefficients{POIvalIDX}(:);
            Coeff(1:M ~= order) = 0;


            % Assign coefficients to QuasiDataObj
            CoeffStr = ['Coeff', this.ApproxType];
            this.QuasiDataObj.(CoeffStr) = Coeff;

            % Temporarily set colloidVelocity to zero
            colloidVelocity = this.QuasiDataObj.colloidVelocity;
            this.QuasiDataObj.colloidVelocity = 0;

            % Graph streamlines
            this.QuasiDataObj.graphStreamlines(this.ApproxType)

            % Return colloidVelocity to original value
            this.QuasiDataObj.colloidVelocity = colloidVelocity;
            

            


        end

        function graphResidues(this, idx)

            load(this.fetchLoadStr);

            this.assignCoefficients(QuasiObj, idx);
            QuasiObj.graphResidues(this.ApproxType);


        end

        

        function str = fetchLoadStr(this)
            str = ['/Development/repos/Quasi2DCode/Data/', this.seriesID];          
                
        end

        function assignCoefficients(this, order)
            
            CoeffStr = ['Coeff', this.ApproxType];
            this.QuasiDataObj.(CoeffStr) = this.Coefficients{order};


        end


    end
end