function experiment_varying_tratio(TratioMin, TratioMax, TratioStep, Pi, mDelta, U, Umax, casesNo, hwType)

scheduler = 'gedf';
fileName = 'output/varying_Tratio.txt';
GmprOPSolver = 'active-set';

warning('query', 'all');
warning('off','all');

caseItr = 1;
while caseItr <= casesNo
    
    tasks = generate_taskset(U, Umax, TratioMax);
    disp(['case no: ' int2str(caseItr)]);
    
    valid = 1;
     for Tratio = TratioMax:-TratioStep:TratioMin

        tasks = update_taskset_for_new_Tratio(tasks, Umax, Tratio);
        mMin = compute_m(tasks, scheduler);
        m = mMin + mDelta;
        
        try
            tic
            gmpr = compute_gmpr(tasks, m, Pi, scheduler, GmprOPSolver);
            timeGmpr = toc;
            Ugmpr = (gmpr.thetas(end))/Pi;
     
            tic
            mpr = compute_mpr(tasks, m, Pi, scheduler);
            timeMpr = toc;
            Umpr = (mpr.theta)/Pi;

            GainGmprMpr = round((Umpr - Ugmpr)*10000/Ugmpr)/100;
            if GainGmprMpr < 0
                disp('error due to OP solver');
                valid = 0;
                break;
            end
            
            disp(['Tratio: ' num2str(Tratio) ' n: ' int2str(numel(tasks)) ' m: ' int2str(m) '   gain GMPR vs MPR: ' num2str(GainGmprMpr)]);
        catch
            disp('problem occured! regenerating task set...');
            valid = 0;
            break;
        end
        
        results(1) = U;
        results(2) = Umax;
        results(3) = Tratio;        
        results(4) = numel(tasks);
        results(5) = m;        
        results(6) = mDelta;
        results(7) = Pi;
        results(8) = Ugmpr;
        results(9) = Umpr;
        results(10) = timeGmpr;
        results(11) = timeMpr;
        results(12) = hwType;
        if strcmpi(scheduler, 'gedf')
            results(13) = 1;
        elseif strcmpi(scheduler, 'gfp')
            results(13) = 2;
        end
        
        dlmwrite(fileName, results, '-append', 'delimiter', ' ', 'precision', 6, 'newline', 'pc');
    end % for UmaxItr
    
    if valid == 1
        caseItr = caseItr + 1;
    end
    
end % while caseItr

end