function [idx, element] = closestelement(x, target)
% FIND CLOSEST ELEMENT OF A VECTOR X

    element = x(1);
    idx = 1;

    for i = 1:length(x)
        if abs(target - x(i)) < abs(target - element)
            element = x(i);
            idx = i;
        end
    end


end