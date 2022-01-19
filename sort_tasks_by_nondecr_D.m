% Sort tasks in the order of non-decreasing D
function sorted_tasks_nondecr_D = sort_tasks_by_nondecr_D(tasks)

sorted_tasks_nondecr_D = struct('C', {}, 'T', {}, 'D', {}, 'Wedf', {}, 'Wfp', {}, 'P', {}, 'kBarEdf', {}, 'kBarFp', {});

for i = 1:numel(tasks)
   sorted_tasks_nondecr_D = add_task(sorted_tasks_nondecr_D, tasks(i)); 
end

end



% Append task to the sorted list by increasing T
function sorted_tasks = add_task(sorted_tasks, task)

if (numel(sorted_tasks) == 0)
    sorted_tasks(1) = task;
    return;
end

%new_sorted_tasks = zeros(numel(sorted_tasks), 1);
new_sorted_tasks = struct('C', {}, 'T', {}, 'D', {}, 'Wedf', {}, 'Wfp', {}, 'P', {}, 'kBarEdf', {}, 'kBarFp', {});

for k = 1:numel(sorted_tasks)
    
    cur_task = sorted_tasks(k);
    if (task.D <= cur_task.D)
        new_sorted_tasks(1:k-1) = sorted_tasks(1:k-1);
        new_sorted_tasks(k) = task;
        new_sorted_tasks(k+1) = cur_task;
        new_sorted_tasks(k+2:(numel(sorted_tasks)+1)) = sorted_tasks(k+1:end);
        sorted_tasks = new_sorted_tasks;
        return;
    end
    
end

sorted_tasks(k+1) = task;

end