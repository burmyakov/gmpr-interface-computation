function plot_interface_U_for_varying_Umax(UmaxMin, UmaxMax, UmaxStep, U, Tratio, mDelta, Pi, scheduler)

fileName = 'output/varying_Umax.txt';
Umaxs = [];
avGmprUs = [];
avMprUs = [];

gmprGains = [];
avGmprGains = [];

obsNos = [];

for Umax = UmaxMin:UmaxStep:UmaxMax
    
    results = get_results(fileName, U, Umax, Tratio, mDelta, [], [], Pi, scheduler);
    if isempty(results)
        continue;
    end
    
    Umaxs(1,end+1) = Umax;
    avGmprUs(end+1) = mean(results(:,8));
    avMprUs(end+1) = mean(results(:,9));
    
    curGainsOverMpr = [];
    for rowItr = 1:size(results,1)
        curGainsOverMpr(rowItr,1) = (results(rowItr,9) - results(rowItr,8))*100/results(rowItr,8);
    end
    gmprGains = merge_gain_results(gmprGains, curGainsOverMpr);
end % for UmaxItr

plot_interface_utilizations(Umaxs, avGmprUs, avMprUs);
plot_gain_percentiles(gmprGains, avGmprGains, Umaxs);

end





function plot_interface_utilizations(Umaxs, avGmprUs, avMprUs)

figure(1);

hGmpr = plot(Umaxs, avGmprUs, '-o', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'black');
hold on;
hMpr = plot(Umaxs, avMprUs, '-+', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'black');
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize',20);

grid on;

xlabel('Maximum task utilization,   U_{max}', 'FontSize', 20);
ylabel('Interface utilization,   \Theta_m / \Pi', 'FontSize', 20);

legend([hGmpr hMpr], {'GMPR' 'MPR'});
legend('Location', 'Best');
axis([min(Umaxs) max(Umaxs) (min(avGmprUs)-0.2) (max(avMprUs)+0.2)]);

%print -dpdf -r0 experiments/VaryingUmax.pdf
%saveTightFigure(figure(1), 'experiments/VaryingUmax.pdf');

end




function plot_gain_percentiles(gmprGains, avGmprGains, Umaxs)

figure(2);

xlabels = get_xlabels(Umaxs);
hPercentiles = boxplot(gmprGains, 'labels', xlabels);
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize', 20);
set(findobj(gca,'Type','text'),'FontSize',14);

grid on;
xlabel('Maximum task utilization,   U_{max}', 'FontSize', 20);
ylabel('Gain of GMPR over MPR,   %', 'FontSize', 20);

text_h = findobj(gca, 'Type', 'text');

for cnt = 1:length(text_h)
    text(length(text_h) - cnt +1, 0, get(text_h(cnt), 'string'), 'FontSize', 20,...
        'HorizontalAlignment', 'center', 'Position', [(length(text_h)-cnt+1) -3.5 0]);
end

delete(text_h);

end