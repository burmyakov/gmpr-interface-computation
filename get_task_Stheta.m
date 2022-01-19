function Stheta_task = get_task_Stheta(task, kStar, m, Pi, scheduler)

Stheta_task = zeros(m,2);

% get upper bounds
for thetaItr = 1:m
    Stheta_task(thetaItr,2) = get_uTheta(thetaItr, kStar, task, Pi, Stheta_task, scheduler);
end

% get lower bounds
for thetaItr = m:-1:1
    Stheta_task(thetaItr,1) = get_lTheta(thetaItr, kStar, task, Pi, Stheta_task, scheduler);
end

end



function uTheta = get_uTheta(k, kStar, task, Pi, Stheta_task, scheduler)

C = task.C;
D = task.D;

if strcmpi(scheduler, 'gedf')
    W = task.Wedf;
elseif strcmpi(scheduler, 'gfp')
    W = task.Wfp;
end

if k == 1 && kStar == 1
    uTheta = Pi;
    return;
    
elseif k == 1 && k < kStar
    value1 = 0.25*Pi*((2 - D/Pi) + sqrt((D/Pi - 2)^2 + (8/Pi)*(C + W)));
    uTheta = min(value1, Pi);
    return;
    
elseif k > 1 && k < kStar
    value1 = (0.25*k*Pi)*((2 - D/Pi) + sqrt((D/Pi - 2)^2 + (8/(Pi*k))*(k*C + W)));
    value2 = k*Stheta_task(k-1,2)/(k-1);
    uTheta = min(value1, value2);
    return;
    
elseif k >= kStar && k > 1
    uTheta = k*Stheta_task(k-1,2)/(k-1);
    return;
end

end



function lTheta = get_lTheta(k, kStar, task, Pi, Stheta_task, scheduler)

C = task.C;
D = task.D;

if strcmpi(scheduler, 'gedf')
    W = task.Wedf;
elseif strcmpi(scheduler, 'gfp')
    W = task.Wfp;
end

if k < kStar
    lTheta = k*Stheta_task(kStar,1)/kStar;
else
    lTheta = (Pi/D)*(kStar*C + W);
end

end