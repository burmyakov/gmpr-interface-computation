% Resolve the optimization problem:
% Compute Theta subject to the schedulability constraints.
function [theta, exitflag] = solve_mpr_op(m, Pi, tasks, kSet, Stheta, scheduler)

task_constraints = get_task_constraints(numel(tasks), scheduler);
theta_constraints = get_theta_constraint();

c = eval(['@(theta)[', task_constraints, theta_constraints, ']']);
ceq = @(theta)[];

nonlinconstraints = @(theta)deal(c(theta), ceq(theta));
fobj = @(theta)(theta);

startPoint = m*Pi;
lTheta = Stheta(m,1);
uTheta = Stheta(m,2);

options = optimset('Display', 'none', 'MaxFunEval', 100000, 'MaxIter', 10000, 'Algorithm', 'interior-point');
[~, theta, exitflag] = fmincon(fobj, startPoint, [], [], [], [], lTheta, uTheta, nonlinconstraints, options);
    
end





% Get schedulability constraints for each task
function task_constraints = get_task_constraints(n, scheduler)

task_constraints = [];

for i = 1:n
    if strcmpi(scheduler, 'gedf')
        cur_constraint = strcat('constraint_EDF(tasks(', int2str(i), '), kSet(', int2str(i), '), m, theta, Pi); ');
    elseif strcmpi(scheduler, 'gfp')
        cur_constraint = strcat('constraint_FP(tasks(', int2str(i), '), kSet(', int2str(i), '), m, theta, Pi); ');
    end
    task_constraints = strcat(task_constraints, cur_constraint);
end
end




% Get constraints emposed by the MPR definition
function theta_constraint = get_theta_constraint()

theta_constraint = '-theta; theta - m*Pi';
    
end



% Schedulability constraint for a task:
% Yk(Di,Theta) >= kCi + Wi
function value = constraint_EDF(task, k, m, theta, Pi) % used in evalscript

value = (k*task.C + task.Wedf) - get_mpr_psf_k(k, m, theta, task.D, Pi);

end


function value = constraint_FP(task, k, m, theta, Pi) % used in evalscript

value = (k*task.C + task.Wfp) - get_mpr_psf_k(k, m, theta, task.D, Pi);

end