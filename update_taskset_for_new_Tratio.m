function newTasks = update_taskset_for_new_Tratio(tasks, Umax, Tratio)

Tmin = 20;

newTasks = struct('C', {}, 'T', {}, 'D', {}, 'Wedf', {}, 'Wfp', {}, 'P', {}, 'kBarEdf', {}, 'kBarFp', {});

% identify Usum of tasks violating the Tratio condition
Ulack = 0;
for taskItr = numel(tasks):-1:1
    curC = tasks(taskItr).C;
    curT = tasks(taskItr).T;
    if curT/Tmin > Tratio
        Ulack = Ulack + curC/curT;
    else
        newTasks(end+1) = tasks(taskItr);
    end
end

% generate tasks for lacking U
if Ulack > 0
    addTasks = generate_taskset(Ulack, Umax, Tratio);
    elFirst = numel(newTasks) + 1;
    elLast = elFirst + numel(addTasks) - 1;
    newTasks(elFirst:elLast) = addTasks(:);
end

newTasks = compute_Ws(newTasks);

% compute ki bar
for i = 1:numel(newTasks)
    [newTasks(i).kBarEdf,newTasks(i).kBarFp] = compute_kBar(newTasks(i));
end

newTasks = sort_tasks_by_nondecr_D(newTasks);

end