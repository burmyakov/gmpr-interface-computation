function [kBarEdf,kBarFp] = compute_kBar(task)

kBarEdf = ceil(task.Wedf/(task.D - task.C));
if kBarEdf <= 0
    kBarEdf = 1;
end

kBarFp = ceil(task.Wfp/(task.D - task.C));
if kBarFp <= 0
    kBarFp = 1;
end

end