function plot_interface_U_for_varying_deltaM(deltaM_min, deltaM_max, U, Umax, Tratio, Pi, scheduler)

fileName = 'output/varying_deltaM.txt';
deltaMs = [];
avGmprUs = [];
avMprUs = [];

GainsOverMpr = [];
gmprGains = [];
avGmprGains = [];

avGmprVpUs = [];
avMprVpUs = [];

for deltaM = deltaM_min:deltaM_max
    results = get_results(fileName, U, Umax, Tratio, deltaM, [], [], Pi, scheduler);

    if isempty(results)
        %disp('No results found for the specified criteria!');
        continue;
    end
    
    deltaMs(end+1) = deltaM;
    avGmprUs(end+1) = mean(results(:,8));
    avMprUs(end+1) = mean(results(:,9));
    
    curGmprVpUs = [];
    curMprVpUs = [];
    for itr = 1:size(results,1)
        curGmprVpUs(end+1) = results(itr,8)/results(itr,5);
        curMprVpUs(end+1) = results(itr,9)/results(itr,5);
    end
    avGmprVpUs(end+1) = mean(curGmprVpUs);
    avMprVpUs(end+1) = mean(curMprVpUs);
    
    curGainsOverMpr = [];
    for rowItr = 1:size(results,1)
        curGainsOverMpr(rowItr,1) = (results(rowItr,9) - results(rowItr,8))*100/results(rowItr,8);
    end
    GainsOverMpr = merge_gain_results(GainsOverMpr, curGainsOverMpr);
end % for UmaxItr

%plot_interface_utilizations(deltaMs, avGmprUs, avMprUs);
plot_avg_vp_u(deltaMs, avGmprVpUs, avMprVpUs);
plot_gain_percentiles(GainsOverMpr, deltaMs);

end




function plot_interface_utilizations(deltaMs, avGmprUs, avMprUs)

figure(1)
hGmpr = plot(deltaMs, avGmprUs, '-o', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'black');
hold on;
hMpr = plot(deltaMs, avMprUs, '-x', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'black');
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize',20);
whitebg('white');

grid on;

xlabel('Parallelism increment,   \Delta_{m}', 'FontSize', 20);
ylabel('Interface utilization,   \Theta_m / \Pi', 'FontSize', 20);

legend([hGmpr hMpr], {'GMPR' 'MPR'});
axis([min(deltaMs) max(deltaMs) (min(avGmprUs)-0.2) (max(avMprUs)+0.2)]);

end




function plot_avg_vp_u(deltaMs, avGmprVpUs, avMprVpUs)

figure(1)
hGmpr = plot(deltaMs, avGmprVpUs, '-o', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'black');
hold on;
hMpr = plot(deltaMs, avMprVpUs, '-+', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'black');
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize',20);
whitebg('white');

grid on;

xlabel('Parallelism increment,   \Delta_{m}', 'FontSize', 20);
ylabel('VP utilization,   \Theta_m / (m \Pi )', 'FontSize', 20);

legend([hGmpr hMpr], {'GMPR' 'MPR'});
axis([min(deltaMs) max(deltaMs) (min(avGmprVpUs)-0.02) (max(avMprVpUs)+0.02)]);

end






function plot_gain_percentiles(gmprGains, deltaMs)

figure(2);

hPercentiles = boxplot(gmprGains, 'labels', deltaMs);
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize', 20);
set(findobj(gca,'Type','text'),'FontSize',20);

grid on;

xlabel('Parallelism increment,   \Delta{m}', 'FontSize', 20);
ylabel('Gain of GMPR over MPR,   %', 'FontSize', 20);

text_h = findobj(gca, 'Type', 'text');

for cnt = 1:length(text_h)
    text(length(text_h) - cnt +1, 0, get(text_h(cnt), 'string'), 'FontSize', 20,...
        'HorizontalAlignment', 'center', 'Position', [(length(text_h)-cnt+1) -4 0]);
end

delete(text_h);

end