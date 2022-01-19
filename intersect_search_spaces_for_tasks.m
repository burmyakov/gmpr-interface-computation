function [SthetaNew,isEmpty] = intersect_search_spaces_for_tasks(Stheta, SthetaCur)

isEmpty = 0;
SthetaNew = zeros(size(Stheta,1), 2);

for thetaItr = 1:size(Stheta,1)
    thetaMinPrev = Stheta(thetaItr,1);
    thetaMaxPrev = Stheta(thetaItr,2);
    
    thetaMinCur = SthetaCur(thetaItr,1);
    thetaMaxCur = SthetaCur(thetaItr,2);
    
    thetaMin = max(thetaMinPrev, thetaMinCur);
    thetaMax = min(thetaMaxPrev, thetaMaxCur);
    
    if thetaMin > thetaMax
        isEmpty = 1;
        return;
    end
    
    SthetaNew(thetaItr,1) = thetaMin;
    SthetaNew(thetaItr,2) = thetaMax;
end

end