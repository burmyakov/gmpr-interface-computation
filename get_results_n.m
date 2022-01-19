function results = get_results_n(fileName, U, Umax, TRatio, n, mDelta, mRatio, m, Pi, scheduler, hwType)

allResults = dlmread(fileName);
results = [];

for rowItr = 1:size(allResults,1)
    
    curRow(1,:) = allResults(rowItr,:);
    
    if ~isempty(U)
        if round(curRow(1)*10) ~= round(U*10)
            continue;
        end
    end
    
    if ~isempty(Umax)
        if round(curRow(2)*1000) ~= round(Umax*1000)
            continue;
        end
    end
    
    if ~isempty(TRatio)
        if round(curRow(3)*10) ~= round(TRatio*10)
            continue;
        end
    end
    
    if ~isempty(n)
        if curRow(4) ~= n
            continue;
        end
    end
    
    if ~isempty(mDelta)
        if curRow(6) ~= mDelta
            continue;
        end
    end
    
    if ~isempty(mRatio)
        m = curRow(5);
        mDelta = curRow(6);
        mMin = m - mDelta;
        curMRatio = m/mMin;
        
        if round(curMRatio*10) ~= round(mRatio*10)
            continue;
        end
    end
    
    if ~isempty(m)
        if curRow(5) ~= m
            continue;
        end
    end
    
    if ~isempty(Pi)
        if round(curRow(7)*10) ~= round(Pi*10)
            continue;
        end
    end
    
    if ~isempty(scheduler)
        if curRow(13) ~= scheduler
            continue;
        end
    end
    
    if ~isempty(hwType)
        if curRow(12) ~= hwType
            continue;
        end
    end

    % the row satisfies the selection criteria
    results = [results; curRow];
end % for rowItr

end