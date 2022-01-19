function gmprGains = merge_gain_results(gmprGains, curGmprGains)

noRows = size(gmprGains,1);
curNoObs = size(curGmprGains,1);

if curNoObs < noRows
    for itr = curNoObs+1:1:noRows
        curGmprGains(end+1,1) = NaN;
    end
end

if noRows < curNoObs
    nansMatrix = NaN([curNoObs - noRows, size(gmprGains,2)]);
    gmprGains = [gmprGains; nansMatrix];
end

gmprGains = [gmprGains curGmprGains];    

end