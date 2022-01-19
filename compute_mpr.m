function mpr = compute_mpr(tasks, m, Pi, scheduler)

if (m == 0)
    disp('Cannot compute K(Theta_m) for m = 0!');
    return;
end

tasksSthetas = get_Sthetas_tasks(tasks, m, Pi, scheduler);

taskItr = 1;
initTheta = m*Pi;
initKSet = [];
initStheta = [];
theta = compute_mpr_theta(taskItr, initTheta, initKSet, initStheta, tasks, tasksSthetas, m, Pi, scheduler);

mpr.Pi = Pi;
mpr.theta = theta;
mpr.m = m;

end




function theta = compute_mpr_theta(taskItr, theta, curKSet, curStheta, tasks, tasksSthetas, m, Pi, scheduler)

if (taskItr == 1)
    %curKSet = zeros(numel(tasks),1);
    
    k1Bar = get_kbar(tasks(1), scheduler);
    for k1 = m:-1:k1Bar
        curStheta(:,:) = tasksSthetas(taskItr, k1, :, :);
        
        curKSet(1) = k1;
        if taskItr < numel(tasks)
            test = check_opt_criteria(taskItr, theta, curKSet, curStheta, m, tasks, Pi, scheduler);
            if test <= 0
                continue;
            end
        end
        
        theta = compute_mpr_theta(taskItr+1, theta, curKSet, curStheta, tasks, tasksSthetas, m, Pi, scheduler);
    end
    
elseif (taskItr >= 2)&&(taskItr <= numel(tasks))
    
    kiBar = get_kbar(tasks(taskItr), scheduler);
    
    for ki = kiBar:m
        taskStheta(:,:) = tasksSthetas(taskItr, ki, :, :);
        
        [SthetaNew, isEmpty] = intersect_search_spaces_for_tasks(curStheta, taskStheta);
        if isEmpty
            continue;
        end
        
        curKSet(taskItr) = ki;
        
        if taskItr < numel(tasks)
            test = check_opt_criteria(taskItr, theta, curKSet, SthetaNew, m, tasks, Pi, scheduler);
            if test <= 0
                continue;
            end
        end
        
        theta = compute_mpr_theta(taskItr+1, theta, curKSet, SthetaNew, tasks, tasksSthetas, m, Pi, scheduler);
    end
else % i > numel(tasks)
    if (max(curKSet) == m)
        [curTheta, exitflag] = solve_mpr_op(m, Pi, tasks, curKSet', curStheta, scheduler);
        
        if exitflag > 0
            %disp(['MPR kset: ' mat2str(curKSet') ' opt theta: ' num2str(curTheta) ' min theta: ' num2str(theta)]);
            if theta > curTheta
                theta = curTheta;
            end
        else
            %disp(['kset: ' mat2str(curKSet') ' not feasible']);
            return;
        end
    else
        % ignore the k-set
    end
end

end




function tasksSthetas = get_Sthetas_tasks(tasks, m, Pi, scheduler)

tasksSthetas = [];
for taskItr = 1:numel(tasks)
    task = tasks(taskItr);
    
    kBar = get_kbar(task, scheduler);
    for kStarItr = 1:(kBar-1)
        tasksSthetas(taskItr, kStarItr, 1:m, 1:2) = NaN;
    end
    
    for kStarItr = kBar:m
        curSthetaTask = get_task_Stheta(task, kStarItr, m, Pi, scheduler);
        tasksSthetas(taskItr, kStarItr, 1:m, 1:2) = curSthetaTask(:,:);
    end
end

end




function valid = check_opt_criteria(i, minTheta, kSet, Stheta, m, tasks, Pi, scheduler)

curTasks = struct('C', {}, 'T', {}, 'D', {}, 'Wedf', {}, 'Wfp', {}, 'P', {}, 'kBarEdf', {}, 'kBarFp', {});
curTasks(1:i) = tasks(1:i);
curKSet(1,1:i) = kSet(1:i);

if Stheta(m,2) > minTheta
    Stheta(m,2) = minTheta;
end

[testTheta, exitflag] = solve_mpr_op(m, Pi, curTasks, curKSet, Stheta, scheduler);
if exitflag > 0
    if round(testTheta*1000) >= round(minTheta*1000)
        valid = -1;
        %disp(['kset: ' mat2str(curKSet) ' does not give better theta ' ' theta: ' num2str(testTheta) ' minTheta: ' num2str(minTheta) ' exitflag: ' int2str(exitflag)]);
        return;
    else
        valid = 1;
        %disp(['kset: ' mat2str(curKSet) ' promises better theta ' ' theta: ' num2str(testTheta) ' minTheta: ' num2str(minTheta) ' exitflag: ' int2str(exitflag)]);
        return;
    end
elseif exitflag <= 0 && i < numel(tasks)
    %disp(['kSet: ' mat2str(curKSet) ' does not give better theta']);
    valid = -1;
    return;
elseif exitflag <= 0 && i == numel(tasks)
    %disp(['kSet: ' mat2str(curKSet) ' infeasible']);
    valid = -1;
    return;
end

end





function [SthetaNew,isEmpty] = intersect_search_spaces_for_tasks(Stheta, SthetaCur)

isEmpty = 0;
SthetaNew = zeros(size(Stheta,1), 2);

for thetaItr = 1:size(Stheta,1)
    thetaMinPrev = Stheta(thetaItr,1);
    thetaMaxPrev = Stheta(thetaItr,2);
    
    thetaMinCur = SthetaCur(thetaItr,1);
    thetaMaxCur = SthetaCur(thetaItr,2);
    
    thetaMin = max(thetaMinPrev, thetaMinCur);
    thetaMax = min(thetaMaxPrev, thetaMaxCur);
    
    if thetaMin > thetaMax
        isEmpty = 1;
        return;
    end
    
    SthetaNew(thetaItr,1) = thetaMin;
    SthetaNew(thetaItr,2) = thetaMax;
end

end