function [CoefficientsB, StatsB] = generateCoefficients(QuasiObj)



    N = 20;
    R = 1:N;

    CoefficientsB   = cell(1, N);
    StatsB          = cell(1, N);


    parfor i = 1:length(R)


        QuasiObj.estimateStreamFunction(4, R(i));
        CoefficientsB{i} = QuasiObj.CoeffB;
        StatsB{i}        = QuasiObj.stats_B;

    end




end