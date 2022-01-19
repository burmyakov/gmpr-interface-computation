function kBar = get_kbar(task, scheduler)

if strcmpi(scheduler, 'gedf')
    kBar = task.kBarEdf;
elseif strcmpi(scheduler, 'gfp')
    kBar = task.kBarFp;
end

end