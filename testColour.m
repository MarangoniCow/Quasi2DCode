x = linspace(-2*pi,2*pi,300); 
y = sin(x); 

clf
% Color changes along x axis
sp(1) = subplot(3,1,1);
c = [x(1:end-1), NaN]; % Must end in NaN to filling a solid
patch(x,y,c, 'EdgeColor', 'interp', 'LineWidth', 3)
title('Color changes along x axis')
axis tight
box on
grid on

% Color changes along y axis
sp(2) = subplot(3,1,2);
c = [y(1:end-1), NaN]; % Must end in NaN to filling a solid
patch(x,y,c, 'EdgeColor', 'interp', 'LineWidth', 3)
title('Color changes along y axis')
axis tight
box on
grid on

% Color changes according to some rule
sp(3) = subplot(3,1,3);
c = [1:150,1:149, nan]; % Must end in NaN to filling a solid
patch(x,y,c, 'EdgeColor', 'interp', 'LineWidth', 3)
title('Color changes according to some rule')
axis tight
box on
grid on