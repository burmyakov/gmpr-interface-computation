% Generate task set having a total utilization U, an individual task
% utilization not exceeding Umax, and the ration Tmax/Tmin.
%
% The idea is to randomly distribute the utilization U between individual
% tasks, then to randomly generate the period T and compute C.
function tasks = generate_taskset(U, Umax, Tmaxmin)

tasks = struct('C', {}, 'T', {}, 'D', {}, 'Wedf', {}, 'Wfp', {}, 'P', {}, 'kBarEdf', {}, 'kBarFp', {});

Tmin = 20;
Tmax = ceil(Tmin*Tmaxmin);

tasks = generate_CTD(U, Umax, Tmin, Tmax, tasks);
tasks = compute_Ws(tasks);

% compute ki bar
for i = 1:numel(tasks)
    [tasks(i).kBarEdf,tasks(i).kBarFp] = compute_kBar(tasks(i));
end

tasks = sort_tasks_by_nondecr_D(tasks);

% for itr = 1:numel(tasks)
%     disp('===========================');
%     disp(['task no: ' int2str(itr)]);
%     disp(['C: ' num2str(tasks(itr).C)]);
%     disp(['D: ' num2str(tasks(itr).D)]);
%     disp(['W: ' num2str(tasks(itr).Wedf)]);
%     disp(['kBarEDF: ' int2str(tasks(itr).kBarEdf)]);
%     disp(['kBarFP: ' int2str(tasks(itr).kBarFp)]);
% end

end




function tasks = generate_CTD(U, Umax, Tmin, Tmax, tasks)

Ur = U;
i = 1;

while (Ur > Umax)
    Ui = rand(1)*Umax;
    
    if Tmax > Tmin
        tasks(i).T = Tmin + randi(Tmax - Tmin);
    else
        tasks(i).T = Tmin;
    end
    
    tasks(i).D = tasks(i).T;
    tasks(i).C = Ui*tasks(i).T;
    
    Ur = Ur - Ui;
    i = i + 1;
end

% the last task
if Tmax > Tmin
    tasks(i).T = Tmin + randi(Tmax - Tmin);
else
    tasks(i).T = Tmin;
end
tasks(i).D = tasks(i).T;
tasks(i).C = Ur*tasks(i).T;

end