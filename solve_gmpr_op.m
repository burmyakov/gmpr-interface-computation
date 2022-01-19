function [theta, exitflag] = solve_gmpr_op(thetaIndx, kSet, Stheta, m, thetas, tasks, Pi, scheduler, OpSolver)

startPoint = get_start_point(thetaIndx, m, thetas, Stheta);

% resolve optimization problem for theta_i
[theta, exitflag] = solve_op_for_theta(thetaIndx, kSet, Stheta, m, thetas, tasks, Pi, startPoint, scheduler, OpSolver);
if (exitflag <= 0)
    return; % OP is infeasible for this kSet
end

end




% Set the start point for the optimization solver
function startPoint = get_start_point(thetaIndx, m, thetas, Stheta)

startPoint(:,1) = Stheta(:,2);

for thetaItr = m:-1:(thetaIndx+1)
    startPoint(thetaItr,1) = thetas(thetaItr);
end

end




function [theta, exitflag] = solve_op_for_theta(thetaIndx, kSet, Stheta, m, thetas, tasks, Pi, startPoint, scheduler, OpSolver)

[consLeft, consRight, ~] = gmpr_op_get_def_constraints(thetaIndx, thetas, m, Pi);
sched_constraints = gmpr_op_get_sched_constraints(thetaIndx, tasks, kSet, scheduler);

c = eval(['@(thetas)[', sched_constraints, ']']);
ceq = eval(['@(thetas)[]']);
%nonlinconstraints = eval(['@(thetas)[', sched_constraints, ']']);
nonlinconstraints = @(thetas)deal(c(thetas), ceq(thetas));

lThetas(1,:) = Stheta(:,1)';
uThetas(1,:) = Stheta(:,2)';

% get known thetas, from Theta_m down to Theta_{thetaIndx+1}
[eqConsLeft, eqConsRight] = get_eq_cons(thetaIndx, m, thetas);

fobj = @(thetas)(thetas(thetaIndx));

options = optimset('Display', 'none', 'MaxFunEval', 100000, 'MaxIter', 10000, 'Algorithm', OpSolver);
[~, theta, exitflag] = fmincon(fobj, startPoint, consLeft, consRight, eqConsLeft, eqConsRight, lThetas, uThetas, nonlinconstraints, options);

end



function [eqConsLeft, eqConsRight] = get_eq_cons(thetaIndx, m, thetas)

eqConsLeft = [];
eqConsRight = [];

for itr = thetaIndx+1:m
    newCons = zeros(1,m);
    newCons(itr) = 1;
    
    eqConsLeft = [eqConsLeft; newCons];
    eqConsRight = [eqConsRight; thetas(itr)];
end

end