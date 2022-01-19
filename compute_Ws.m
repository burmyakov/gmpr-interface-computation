% Gets interfering workloads for EDF and FP
% according to Bertogna
function tasks = compute_Ws(tasks)

tasks = assign_fixed_priorities(tasks); % for FP we use RM priorities

for index = 1:numel(tasks)
    tasks(index).Wedf = get_W_edf(index, tasks);
    tasks(index).Wfp = get_W_fp(index, tasks);
end

end





% get interfering workload Wk for GEDF
function Wi = get_W_edf(i, taskSet)

n = numel(taskSet);
Wi = 0;
Di = taskSet(i).D;

for j = 1:n   
    if (j ~= i)
        Cj = taskSet(j).C;
        Tj = taskSet(j).T;
    
        Wi = Wi + floor(Di / Tj)*Cj + min(Cj, Di - floor(Di / Tj)*Tj);
    end
end

end




function Wi = get_W_fp(i, tasks)

Wi = 0;
Di = tasks(i).D;

for j = 1:(i-1)
    Cj = tasks(j).C;
    Tj = tasks(j).T;
    Dj = tasks(j).D;
    
    Nji = floor((Di + Dj - Cj)/Tj);
    Wji = Nji*Cj + min(Cj, Di + Dj - Cj - Nji*Tj);
    Wi = Wi + Wji;
end

end