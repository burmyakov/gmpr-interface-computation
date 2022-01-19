function [thetas, kSetsForOptThetas] = compute_gmpr_theta_k(k, kSetsForOptThetas, thetas, tasks, tasksSthetas, m, Pi, scheduler, OpSolver)

kSets(:,:) = kSetsForOptThetas{k+1};

for kSetItr = 1:size(kSets,1)
    kSet = kSets(kSetItr,:);
    
    % compute Stheta
    Stheta = get_Stheta_for_kSet(tasksSthetas, kSet);
    
    [curTheta, exitflag] = solve_gmpr_op(k, kSet', Stheta, m, thetas, tasks, Pi, scheduler, OpSolver);
    
    if exitflag > 0
        if thetas(k) > curTheta
            thetas(k) = curTheta;
            kSetsForOptThetas{k} = kSet;
        elseif thetas(k) == curTheta
            kSetsForOptThetas{k} = [kSetsForOptThetas{k}; kSet];
        end
    else
        return;
    end
end

end