% Compute GMPR parallelism m.
% "policy" is a local scheduling policy: GEDF or GFP
function m = compute_m(tasks, policy)

m = 0;

if strcmpi(policy,'GEDF')
    for i = 1:numel(tasks)
        if tasks(i).kBarEdf > m
            m = tasks(i).kBarEdf;
        end
    end
    return;
elseif strcmpi(policy,'GFP')
    for i = 1:numel(tasks)
        if tasks(i).kBarFp > m
            m = tasks(i).kBarFp;
        end
    end
    return;
else
    disp(['Cannot compute m; unknown scheduling policy:' policy]);
    disp('Choose one of these: GEDF, GFP');
end

end