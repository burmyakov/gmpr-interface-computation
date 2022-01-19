% Collect schedulability constraints
function sched_constraints = gmpr_op_get_sched_constraints(thetaIndx, tasks, kSet, policy)

sched_constraints = [];
n = numel(tasks);
noOfConstraints = 0;

for taskItr = 1:n
    curK = kSet(taskItr);
    
    if curK <= thetaIndx
        if strcmpi(policy, 'GEDF')
            cur_constraint = strcat('sched_constraint_EDF(tasks(', int2str(taskItr), '), ', int2str(curK), ', thetas, Pi); ');
        elseif strcmpi(policy, 'GFP')
            cur_constraint = strcat('sched_constraint_FP(tasks(', int2str(taskItr), '), ', int2str(curK), ', thetas, Pi); ');
        end
        
        sched_constraints = strcat(sched_constraints, cur_constraint);
        noOfConstraints = noOfConstraints + 1;
    end
end

end