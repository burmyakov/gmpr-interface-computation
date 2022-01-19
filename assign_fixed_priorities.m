% Assigns fixed RM priorities to tasks
function tasks = assign_fixed_priorities(tasks)

tasksSortedByIncrT = struct('C', {}, 'T', {}, 'D', {}, 'Wedf', {}, 'Wfp', {}, 'P', {}, 'kBarEdf', {}, 'kBarFp', {});

for i = 1:numel(tasks)
   tasksSortedByIncrT = add_task(tasksSortedByIncrT, tasks(i)); 
end


for j = 1:numel(tasksSortedByIncrT)
    tasksSortedByIncrT(j).P = j;
end

tasks = tasksSortedByIncrT;
end




% Append task to the sorted list by increasing T
function sortedTasksList = add_task(sortedTasksList, task)

if (numel(sortedTasksList) == 0)
    sortedTasksList(1) = task;
    return;
end

for k = 1:numel(sortedTasksList)  
    curTask = sortedTasksList(k);
    if (task.T < curTask.T)
        newSortedTasksList(1:k-1) = sortedTasksList(1:k-1);
        newSortedTasksList(k) = task;
        newSortedTasksList(k+1) = curTask;
        newSortedTasksList(k+2:(numel(sortedTasksList)+1)) = sortedTasksList(k+1:end);
        sortedTasksList = newSortedTasksList;
        return;
    end 
end

sortedTasksList(k+1) = task;
end