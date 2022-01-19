function get_runtime()

fileName = 'output/runtime.txt';
Tratio = 10;
mDelta = 3;
Pi = 20;
scheduler = 1;
hwType = 1;

%avGmprTimes = [];
%avMprTimes = [];
ns = [];
gmprTimes = [];
mprTimes = [];

for n = 2:2:36
    disp(['n: ' int2str(n)]);
    
    results = get_results_n(fileName, [], [], Tratio, n, mDelta, [], [], Pi, scheduler, hwType);
    if isempty(results)
        continue;
    end
    
    curGmprTimes = [];
    curMprTimes = [];
    for rowItr = 1:size(results,1)
        curGmprTimes(rowItr,1) = results(rowItr,10);
        curMprTimes(rowItr,1) = results(rowItr,11);
    end
    
    ns(end+1) = n;
    gmprTimes = merge_gain_results(gmprTimes, curGmprTimes);
    mprTimes = merge_gain_results(mprTimes, curMprTimes);
end

plot_gmpr_runtime_percentiles(gmprTimes, ns);
plot_mpr_runtime_percentiles(mprTimes, ns);
    
end




function plot_gmpr_runtime_percentiles(gmprTimes, ns)

figure(1);

xlabels = get_xlabels(ns);
%hPercentiles = boxplot(gmprTimes, 'labels', ns, 'symbol', '');
hPercentiles = boxplot(gmprTimes, 'labels', xlabels);
ylim([0 160]);
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize', 20);
set(findobj(gca,'Type','text'),'FontSize',14);

grid on;

xlabel('Number of tasks,   n', 'FontSize', 20);
ylabel('GMPR computation time,   (sec)', 'FontSize', 20);

text_h = findobj(gca, 'Type', 'text');

for cnt = 1:length(text_h)
    text(length(text_h) - cnt +1, 0, get(text_h(cnt), 'string'), 'FontSize', 20,...
        'HorizontalAlignment', 'center', 'Position', [(length(text_h)-cnt+1) -5 0]);
end

delete(text_h);

end




function plot_mpr_runtime_percentiles(mprTimes, ns)

figure(2);

xlabels = get_xlabels(ns);
hPercentiles = boxplot(mprTimes, 'labels', xlabels);
ylim([0 30]);
hold off;

set(gcf, 'Position', [0 0 1200 800]);
set(gca,'FontSize', 20);
set(findobj(gca,'Type','text'),'FontSize',14);

grid on;

xlabel('Number of tasks,   n', 'FontSize', 20);
ylabel('MPR computation time,   (sec)', 'FontSize', 20);

text_h = findobj(gca, 'Type', 'text');

for cnt = 1:length(text_h)
    text(length(text_h) - cnt +1, 0, get(text_h(cnt), 'string'), 'FontSize', 20,...
        'HorizontalAlignment', 'center', 'Position', [(length(text_h)-cnt+1) -1 0]);
end

delete(text_h);

end