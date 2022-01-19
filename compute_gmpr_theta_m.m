function [thetas, kSetsForOptThetas] = compute_gmpr_theta_m(taskItr, thetas, curKSet, curStheta, tasks, tasksSthetas, m, Pi, scheduler, OpSolver, kSetsForOptThetas)

if (taskItr == 1)
    
    k1Bar = get_kbar(tasks(1), scheduler);
    for k1 = m:-1:k1Bar
        curStheta(:,:) = tasksSthetas(taskItr, k1, :, :);
        
        curKSet(1) = k1;
        if taskItr < numel(tasks)
            test = check_opt_criteria(taskItr, m, thetas(end), thetas, curKSet, curStheta, m, tasks, Pi, scheduler, OpSolver);
            if test <= 0
                continue;
            end
        end
        
        [thetas, kSetsForOptThetas] = compute_gmpr_theta_m(taskItr+1, thetas, curKSet, curStheta, tasks, tasksSthetas, m, Pi, scheduler, OpSolver, kSetsForOptThetas);
    end
    
elseif (taskItr >= 2)&&(taskItr <= numel(tasks))
    
    kiBar = get_kbar(tasks(taskItr), scheduler);
    
    for ki = kiBar:m
        taskStheta(:,:) = tasksSthetas(taskItr, ki, :, :);
        if taskStheta(m,1) > thetas(m)
            continue;
        elseif taskStheta(m,2) > thetas(m)
            taskStheta(m,2) = thetas(m);
        end
        
        [SthetaNew, isEmpty] = intersect_search_spaces_for_tasks(curStheta, taskStheta);
        if isEmpty
            continue;
        end
        
        curKSet(taskItr) = ki;
        
        if taskItr < numel(tasks)
            test = check_opt_criteria(taskItr, m, thetas(end), thetas, curKSet, SthetaNew, m, tasks, Pi, scheduler, OpSolver);
            if test <= 0
                continue;
            end
        end
        
        [thetas, kSetsForOptThetas] = compute_gmpr_theta_m(taskItr+1, thetas, curKSet, SthetaNew, tasks, tasksSthetas, m, Pi, scheduler, OpSolver, kSetsForOptThetas);
    end
else % i > numel(tasks)
    if (max(curKSet) == m)
        
        [curTheta, exitflag] = solve_gmpr_op(m, curKSet', curStheta, m, thetas, tasks, Pi, scheduler, OpSolver);
        
        if exitflag > 0
            if thetas(m) > curTheta
                thetas(m) = curTheta;
                kSetsForOptThetas{m} = curKSet;
            elseif thetas(m) == curTheta
                kSetsForOptThetas{m} = [kSetsForOptThetas{m}; curKSet];
            end
        else
            return;
        end
    else
        % ignore the k-set
    end
end

end



function valid = check_opt_criteria(i, thetaIndx, minTheta, thetas, kSet, Stheta, m, tasks, Pi, scheduler, OpSolver)

curTasks = struct('C', {}, 'T', {}, 'D', {}, 'Wedf', {}, 'Wfp', {}, 'P', {}, 'kBarEdf', {}, 'kBarFp', {});
curTasks(1:i) = tasks(1:i);
curKSet(1,1:i) = kSet(1:i);

if Stheta(thetaIndx,2) > minTheta
    Stheta(thetaIndx,2) = minTheta;
end

[testTheta, exitflag] = solve_gmpr_op(thetaIndx, curKSet, Stheta, m, thetas, curTasks, Pi, scheduler, OpSolver);
if exitflag > 0
    if testTheta >= minTheta
        valid = -1;
        return;
    else
        valid = 1;
        return;
    end
elseif exitflag <= 0 && i < numel(tasks)
    valid = -1;
    return;
elseif exitflag <= 0 && i == numel(tasks)
    valid = -1;
    return;
end

end