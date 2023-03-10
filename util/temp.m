
t = VelObj.timeStep;

x0 = VelObj.colloidDisp(1, t); y0 = VelObj.colloidDisp(2, t); z0 = VelObj.colloidDisp(3, t);
V = VelObj.velocityData{t};
ut = V(:, :, :, 1); vt = V(:, :, :, 2); wt = V(:, :, :, 3);
x = 1:VelObj.systemSize(1); y = 1:VelObj.systemSize(2); z = 1:VelObj.systemSize(3);


[X, Y, Z] = meshgrid(x, y, z);



u = zeros(size(X));
v = zeros(size(Y));
w = zeros(size(Z));



[r, c, h] = size(X);

for i = 1:r

    for j = 1:c

        u(i, j, :) = ut(j, i, :);
        v(i, j, :) = vt(j, i, :);
        w(i, j, :) = wt(j, i, :);

    end


end


colloidRadius = VelObj.colloid_a;
Us = VelObj.colloidVel(1, t).*ones(size(u));
% u = u - Us;

% fig = figure('Name', 'Streamslice Graph');
% 
% 
% streamslice(X, Y, Z,  u, v, w, x0, [], [])
fig = figure('Name', 'Coloured Surface');
ax1 = axes('Parent', fig);




% ColouredStreamslice(X, Y, Z, u, v, w, [], [], z0, ax1);
% ColouredStreamslice(X, Y, Z, u, v, w, [], y0, [], ax1);
ColouredStreamslice(X, Y, Z, u, v, w, [], [], z0, ax1, 0.2);

ColouredStreamslice(X, Y, Z, u, v, w, x0 + 4*colloidRadius, [], [], ax1, []);
ColouredStreamslice(X, Y, Z, u, v, w, x0 - 4*colloidRadius, [], [], ax1, []);


% streamslice(X, Y, Z,  u, v, w, x0 + 60, [], [])
% streamslice(X, Y, Z,  u, v, w, x0 - 25, [], [])
% streamslice(X, Y, Z,  u, v, w, [], y0, [])
% streamslice(X, Y, Z,  u, v, w, [], [], z0)
% streamslice(X, Y, Z,  u, v, w, [], [], z0 + 10)
% streamslice(X, Y, Z,  u, v, w, [], [], z0 + 20)

% fig = figure('Name', 'Coloured Streamslice');



% 
% a = colloidRadius;
% [xs, ys, zs] = sphere;
% xs = xs*a + x0;
% ys = ys*a + y0;
% zs = zs*a + z0;
% 
% ax2 = copyobj(ax1, fig);
% ax2.Color = 'none';
% ax2.XTick = [];
% ax2.YTick = [];
% ax2.ZTick = [];
% 
% % ax2 = axes('Parent', fig, 'NextPlot', 'add', 'Color', 'none', 'XTick',[], 'YTick', [], 'ZTick', []);
% hlink = linkprop([ax1,ax2],{'CameraViewAngle','CameraPosition','CameraUpVector'});
% 
% 
% % Plot colloid
% surf(ax2, xs, ys, zs,'HandleVisibility', 'off', 'EdgeColor','none', 'FaceColor', 'interp');
% % axis equal
% % PlotDefaults.applyEqualAxes;
%  map = zeros(20, 3);
%     for i = 1:20
%         map(i, 3) = 0.25 + i*0.028;
%     end
%     colormap(map)
% 
%     hold off
% 





% % streamslice(X, Y, Z,  u, v, w, x0, [], [])
% streamslice(X, Y, Z,  u, v, w, [], y0, [])

% PlotDefaults.applyDefaultLabels;
% PlotDefaults.applySizes('big');


% fig = figure('Name', 'Streamline Graph');



sx = [1, 100, 200, 210, 220, 300];
r = linspace(0, 48/2, 5);
t = linspace(0, 2*pi, 8);

[R, Th, Sx] = meshgrid(r, t, sx);
[Sy, Sz, Sx] = pol2cart(Th, R, Sx);
Sy = Sy + 128;
Sz = Sz + 24;


sx = 1; 

% sx = linspace(1, 384, 6);
% sy = linspace(1, 256, 20);
% sz = linspace(1, 48, 5);


% u = u(1:n:end, 1:n:end, 1:n:end);
% v = v(1:n:end, 1:n:end, 1:n:end);
% w = w(1:n:end, 1:n:end, 1:n:end);



% streakarrow3d(X, Y, Z, u, v, w, 8);