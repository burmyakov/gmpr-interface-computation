function plot_interface_U_for_varying_Pi(PiMin, PiMax, PiStep, U, Umax, Tratio, mDelta, plotBefore1, scheduler)

fileName = 'output/varying_Pi.txt';
Pis = [];
avGmprUs = [];
avMprUs = [];

GainsOverMpr = [];
avGainsOverMpr = [];
obsNos = [];

if plotBefore1 == 1
    for Pi = 0.01:1:1
        
        results = get_results(fileName, U, Umax, Tratio, mDelta, [], [], Pi, scheduler);
        
        if isempty(results)
            continue;
        end
        
        obsNos(end+1) = size(results,1);

        Pis(end+1) = Pi;
        avGmprUs(end+1) = mean(results(:,8));
        avMprUs(end+1) = mean(results(:,9));
        
        curGainsOverMpr = [];
        for rowItr = 1:size(results,1)
            curGainsOverMpr(rowItr,1) = (results(rowItr,9) - results(rowItr,8))*100/results(rowItr,8);
        end
        GainsOverMpr = merge_gain_results(GainsOverMpr, curGainsOverMpr);
    end % for
end


for Pi = PiMin:PiStep:PiMax

    results = get_results(fileName, U, Umax, Tratio, mDelta, [], [], Pi, scheduler);
    if isempty(results)
        continue;
    end
    
    obsNos(end+1) = size(results,1);

    Pis(end+1) = Pi;
    avGmprUs(end+1) = mean(results(:,8));
    avMprUs(end+1) = mean(results(:,9));
    
    curGainsOverMpr = [];
    for rowItr = 1:size(results,1)
        curGainsOverMpr(rowItr,1) = (results(rowItr,9) - results(rowItr,8))*100/results(rowItr,8);
    end
    GainsOverMpr = merge_gain_results(GainsOverMpr, curGainsOverMpr);
end % for

plot_interface_utilizations(Pis, avGmprUs, avMprUs);
plot_gain_percentiles(GainsOverMpr, Pis);

end




function plot_interface_utilizations(Pis, avGmprUs, avMprUs)

figure(1);

hGmpr = plot(Pis, avGmprUs, '-o', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'black');
hold on;
hMpr = plot(Pis, avMprUs, '-x', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'black');    
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize',20);
whitebg('white');

grid on;

xlabel('Interface period,   \Pi', 'FontSize', 20);
ylabel('Interface utilization,   \Theta_m / \Pi', 'FontSize', 20);

legend([hGmpr hMpr], {'GMPR' 'MPR'});
axis([min(Pis) max(Pis) (min(avGmprUs)-0.2) (max(avMprUs)+0.2)]);

legend('Location', 'Best');

end




function plot_gain_percentiles(GmprGains, Pis)

figure(2);

hPercentiles = boxplot(GmprGains, 'labels', Pis);
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize', 20);
set(findobj(gca,'Type','text'),'FontSize',14);

grid on;

xlabel('Interface period,   \Pi', 'FontSize', 20);
ylabel('Gain of GMPR over MPR,   %', 'FontSize', 20);

text_h = findobj(gca, 'Type', 'text');

for cnt = 1:length(text_h)
    text(length(text_h) - cnt +1, 0, get(text_h(cnt), 'string'), 'FontSize', 20,...
        'HorizontalAlignment', 'center', 'Position', [(length(text_h)-cnt+1) -2.5 0]);
end

delete(text_h);

end