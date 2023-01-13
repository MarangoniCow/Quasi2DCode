% ------------------------------------------------------------- %
% ------------------------------------------------------------- %
%               QUASI-PARAMETER FITTING: OPTIONS
% 
% ------------------------------------------------------------- %
% ------------------------------------------------------------- %

function p = CommonQuasiArg(p)

    % Colloid size
    addOptional(p, 'ColloidRadius', [], ...
                        @(x) isnumeric(x) && isscalar(x))

    addOptional(p, 'PlaneExtractIdx', []);

    % Time-step
    addOptional(p, 'TimeStep', 1, ...
                        @(x) isnumeric(x) && isscalar(x))

    % Simulation name
    addOptional(p, 'SimulationName', '', ...
                        @(x) isstring(x) || ischar(x));

    % Option to keep VelData
    addOptional(p, 'RetainVelData', ...
                        @(x) islogical(x));

end