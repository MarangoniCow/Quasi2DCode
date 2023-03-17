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

        function str = fetchLoadStr(this)
            str = ['/Development/repos/Quasi2DCode/Data/', this.seriesID];          
                
        end
        
        function assignCoefficients(this, order)
            
            CoeffStr = ['Coeff', this.ApproxType];
            this.QuasiDataObj.(CoeffStr) = this.Coefficients{order};
        
        
        end
    end

    methods % GRAPH METHODS
        fig = graphCoefficients(this, order);
        fig = graphFminsum(this);
        fig = graphStreamlines(this, POIvalIDX);
        fig = graphStreamlineModes(this, POIvalIDX, order);
        fig = graphResidues(this, idx);
    end

    methods (Static)
        fig = compareStructCoefficients(QMO_Struct, order, dispStr, dispStrVal);
        fig = compareStructFminsum(QMO_Struct, dispStr, dispStrVal);
        QMO_Struct = generateQuasiCoefficients(QuasiDataObj, varargin);
    end

end