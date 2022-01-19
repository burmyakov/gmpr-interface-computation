function U = get_U(taskSet)

tasksNumber = numel(taskSet);

U = 0;
for i=1:tasksNumber
    U = U + (taskSet(i).C/taskSet(i).T);
end

end