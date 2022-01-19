function Stheta = get_Stheta_for_kSet(taskSthetas, kSet)

for taskItr = 1:numel(kSet)
    if taskItr == 1
        Stheta(:,:) = taskSthetas(taskItr, kSet(taskItr), :,:);
    else
        taskStheta(:,:) = taskSthetas(taskItr, kSet(taskItr), :, :);
        [Stheta, isEmpty] = intersect_search_spaces_for_tasks(Stheta, taskStheta);
        
        if isEmpty
            disp('Thrown exception in get_Stheta_for_kSet: empty search space');
        end
    end
end

end