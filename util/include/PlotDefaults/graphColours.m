
figure


x = linspace(0, 1);

for i = 1:6


    plot(x, x + i, 'color', PlotDefaults.fetchColourByIdx(i, 10));
    hold on;





end
hold off