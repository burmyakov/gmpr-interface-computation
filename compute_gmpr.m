function gmpr = compute_gmpr(tasks, m, Pi, scheduler, OpSolver)

if (m == 0)
    disp('Cannot compute K(Theta_m) for m = 0!');
    return;
end

thetas = compute_gmpr_thetas(tasks, m, Pi, scheduler, OpSolver);

gmpr.Pi = Pi;
gmpr.thetas = round(thetas*100)/100;

end



function thetas = compute_gmpr_thetas(tasks, m, Pi, scheduler, OpSolver)

taskItr = 1;
initThetas = Pi:Pi:m*Pi;
initKSet = [];
initStheta = [];
tasksSthetas = get_Sthetas_tasks(tasks, m, Pi, scheduler);
kSetsForOptThetaM = cell(m);

[thetas, kSetsForOptThetaM] = compute_gmpr_theta_m(taskItr, initThetas, initKSet, initStheta, tasks, tasksSthetas, m, Pi, scheduler, OpSolver, kSetsForOptThetaM);

kSetsForOptThetas = kSetsForOptThetaM;
for thetaItr = m-1:-1:1
    [thetas, kSetsForOptThetas] = compute_gmpr_theta_k(thetaItr, kSetsForOptThetas, thetas, tasks, tasksSthetas, m, Pi, scheduler, OpSolver);
end

end




function tasksSthetas = get_Sthetas_tasks(tasks, m, Pi, scheduler)

tasksSthetas = [];
for taskItr = 1:numel(tasks)
    task = tasks(taskItr);
    
    if strcmpi(scheduler, 'gedf')
        kBar = task.kBarEdf;
    elseif strcmpi(scheduler, 'gfp')
        kBar = task.kBarFp;
    end
    
    for kStarItr = 1:(kBar-1)
        tasksSthetas(taskItr, kStarItr, 1:m, 1:2) = NaN;
    end
    
    for kStarItr = kBar:m
        curSthetaTask = get_task_Stheta(task, kStarItr, m, Pi, scheduler);
        tasksSthetas(taskItr, kStarItr, 1:m, 1:2) = curSthetaTask(:,:);
    end
end

end