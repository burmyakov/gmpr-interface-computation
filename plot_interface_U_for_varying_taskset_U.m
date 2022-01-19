function plot_interface_U_for_varying_taskset_U(U_min, U_max, Ustep, Umax, Tratio, mDelta, Pi, scheduler)

fileName = 'output/varying_U.txt';
Us = [];
avGmprUs = [];
avMprUs = [];

gmprGains = [];
avGmprGains = [];
avGmprURatios = [];
avMprURatios = [];

avMRatios = [];

for U = U_min:Ustep:U_max
    
    results = get_results(fileName, U, Umax, Tratio, mDelta, [], [], Pi, scheduler);
    if isempty(results)
        continue;
    end
    
    Us(1,end+1) = U;
    avGmprUs(end+1) = mean(results(:,8));
    avMprUs(end+1) = mean(results(:,9));
    
    avGmprURatios(end+1) = avGmprUs(end)/U;
    avMprURatios(end+1) = avMprUs(end)/U;
    
    curGainsOverMpr = [];
    for rowItr = 1:size(results,1)
        curGainsOverMpr(rowItr,1) = (results(rowItr,9) - results(rowItr,8))*100/results(rowItr,8);
    end
    gmprGains = merge_gain_results(gmprGains, curGainsOverMpr);
    
    curDeltaMSum = 0;
    curMminSum = 0;
    for rowItr = 1:size(results,1)
        curDeltaMSum = curDeltaMSum + results(rowItr,6);
        curMminSum = curMminSum + (results(rowItr,5) - results(rowItr,6));
    end
    
    avMRatios(end+1) = curDeltaMSum/curMminSum;
end % for UItr

avGmprGains = compute_avg_gmpr_gains(avGmprUs, avMprUs);
%plot_results(Us, avGmprUs, avMprUs, avGmprGains);
plot_results(Us, avGmprUs, avMprUs, avMRatios);
%plot_results2(Us, avGmprURatios, avMprURatios, avGmprGains);
plot_gain_percentiles(gmprGains, avGmprGains, Us);

end





function avGmprGains = compute_avg_gmpr_gains(avGmprUs, avMprUs)

avGmprGains = zeros(1,numel(avGmprUs));

for itr = 1:numel(avGmprUs)
    avGmprGains(itr) = (avMprUs(itr) - avGmprUs(itr))*100/avGmprUs(itr);
end

end






function plot_results(Us, avGmprUs, avMprUs, avMRatios)

figure(1);

[ax, h1, h2] = plotyy(Us, [avGmprUs' avMprUs'], Us, avMRatios);

set(get(ax(1), 'Ylabel'), 'String', 'Interface utilization,   \Theta_m / \Pi', 'FontSize', 20);
set(get(ax(2), 'Ylabel'), 'String', 'Relative increment,   \Delta{m} / m_{min}', 'FontSize', 20, 'Color', 'blue');

set(h1(1), 'LineStyle', '-', 'marker', 'o', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'k');
set(h1(2), 'LineStyle', '-', 'marker', '+', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'k');
set(h2,'LineStyle', '--', 'marker', '*', 'LineWidth', 1.7, 'Color', 'blue');


set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize', 20);

grid on;

xlabel('Task set utilization,   U', 'FontSize', 20);

legend(ax(1), 'GMPR utilization', 'MPR utilization');
legend(ax(2), 'Ratio, \Delta{m} / m');

end




% function plot_results2(Us, avGmprURatios, avMprURatios, avGmprGains)
% 
% figure(2);
% 
% [ax, h1, h2] = plotyy(Us, [avGmprURatios' avMprURatios'], Us, avGmprGains);
% 
% set(get(ax(1), 'Ylabel'), 'String', 'Interface utilization,   \Theta_m / \Pi', 'FontSize', 16);
% set(get(ax(2), 'Ylabel'), 'String', 'Gain  of  GMPR  vs  MPR,   %', 'FontSize', 16, 'Color', 'blue');
% 
% set(h1(1), 'LineStyle', '-', 'marker', 'x', 'LineWidth', 1.2, 'Color', 'k');
% set(h1(2), 'LineStyle', '-', 'marker', 'o', 'LineWidth', 1.2, 'Color', 'k');
% set(h2,'LineStyle', '--', 'marker', '*', 'LineWidth', 1.7, 'Color', 'blue');
% 
% 
% set(gcf, 'Position', [0 0 1200 800]);
% set(gca,'FontSize', 16);
% 
% grid on;
% 
% xlabel('Task set utilization,   U', 'FontSize', 16);
% 
% legend(ax(1), 'GMPR', 'MPR');
% legend(ax(2), 'GMPR gain over MPR');
% 
% end




function plot_gain_percentiles(gmprGains, avGmprGains, Us)

figure(3);

%xlabels = get_xlabels(Us);
hPercentiles = boxplot(gmprGains, 'labels', Us);
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize', 20);
set(findobj(gca,'Type','text'),'FontSize',20);

grid on;
xlabel('Maximum task utilization,   U_{max}', 'FontSize', 20);
ylabel('Gain of GMPR over MPR,   %', 'FontSize', 20);

text_h = findobj(gca, 'Type', 'text');
for cnt = 1:length(text_h)
    text(length(text_h) - cnt +1, 0, get(text_h(cnt), 'string'), 'FontSize', 20,...
        'HorizontalAlignment', 'center', 'Position', [(length(text_h)-cnt+1) -5 0]);
end
delete(text_h);

end