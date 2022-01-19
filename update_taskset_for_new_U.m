function newTasks = update_taskset_for_new_U(tasks, U, Umax, Tratio)

newTasks = struct('C', {}, 'T', {}, 'D', {}, 'Wedf', {}, 'Wfp', {}, 'P', {}, 'kBarEdf', {}, 'kBarFp', {});

Unew = 0;
for itr = 1:numel(tasks)
    if Unew + tasks(itr).C/tasks(itr).D <= U
        newTasks(end+1) = tasks(itr);
        Unew = get_U(newTasks);
    else
        break;
    end
end

Ulack = U - Unew;

if Ulack > 0
    % generate tasks for lacking U
    addTasks = generate_taskset(Ulack, Umax, Tratio);
    elFirst = numel(newTasks) + 1;
    elLast = elFirst + numel(addTasks) - 1;
    newTasks(elFirst:elLast) = addTasks(:);
end

newTasks = compute_Ws(newTasks);
for i = 1:numel(newTasks)
    [newTasks(i).kBarEdf,newTasks(i).kBarFp] = compute_kBar(newTasks(i));
end
newTasks = sort_tasks_by_nondecr_D(newTasks);

end