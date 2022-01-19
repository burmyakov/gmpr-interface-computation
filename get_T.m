function [Tmax, Tmin, Tavg] = get_T(tasks)

Ts = zeros(1,numel(tasks));

for itr = 1:numel(tasks)
    Ts(itr) = tasks(itr).T;
end

Tmax = max(Ts);
Tmin = min(Ts);
Tavg = mean(Ts);

end