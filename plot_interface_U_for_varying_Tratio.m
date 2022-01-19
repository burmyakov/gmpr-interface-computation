function plot_interface_U_for_varying_Tratio(TratioMin, TratioMax, TratioStep, U, Umax, mDelta, Pi, scheduler)

fileName = 'output/varying_Tratio.txt';
Tratios = [];
avGmprUs = [];
avMprUs = [];

gmprGains = [];
avGmprGains = [];

for Tratio = TratioMin:TratioStep:TratioMax

    results = get_results(fileName, U, Umax, Tratio, mDelta, [], [], Pi, scheduler);
    if isempty(results)
        continue;
    end    
    
    % compute average values
    Tratios(end+1) = Tratio;
    avGmprUs(end+1) = mean(results(:,8));
    avMprUs(end+1) = mean(results(:,9));
    
    curGainsOverMpr = [];
    for rowItr = 1:size(results,1)
        curGainsOverMpr(rowItr,1) = (results(rowItr,9) - results(rowItr,8))*100/results(rowItr,8);
    end
    gmprGains = merge_gain_results(gmprGains, curGainsOverMpr);   
end % for TratioItr

plot_interface_utilizations(Tratios, avGmprUs, avMprUs);
plot_gain_percentiles(gmprGains, avGmprGains, Tratios);

end




function plot_interface_utilizations(Tratios, avGmprUs, avMprUs)

%figure('PaperSize',[29 20],'PaperPosition',[0, 0, 116, 80]);
hFig = figure(1);
%set(hFig, 'PaperSize', [29 20], 'Position', [0 0 29 20]);

hGmpr = plot(Tratios, avGmprUs, '-o', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'black');
hold on;
hMpr = plot(Tratios, avMprUs, '-+', 'LineWidth', 1.2, 'MarkerSize', 10, 'Color', 'black');
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize',20);
whitebg('white');

grid on;

xlabel('Ratio, T_{max}/T_{min}', 'FontSize', 20);
ylabel('Interface utilization, \Theta_m / \Pi', 'FontSize', 20);

legend([hGmpr hMpr], {'GMPR' 'MPR'});
axis([min(Tratios) max(Tratios) (min(avGmprUs)-0.2) (max(avMprUs)+0.2)]);

legend('Location', 'Best');

%print -dpdf -r0 output/VaryingTratio.pdf

end




function plot_gain_percentiles(gmprGains, avGmprGains, Tratios)

figure(2);

xlabels = get_xlabels(Tratios);
hPercentiles = boxplot(gmprGains, 'labels', xlabels);
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize', 20);
set(findobj(gca,'Type','text'),'FontSize',20);

grid on;

xlabel('Ratio T_{max}/T_{min}', 'FontSize', 20);
ylabel('Gain of GMPR over MPR, %', 'FontSize', 20);

text_h = findobj(gca, 'Type', 'text');
for cnt = 1:length(text_h)
    text(length(text_h) - cnt +1, 0, get(text_h(cnt), 'string'), 'FontSize', 20,...
        'HorizontalAlignment', 'center', 'Position', [(length(text_h)-cnt+1) -4.25 0]);
end
delete(text_h);

end