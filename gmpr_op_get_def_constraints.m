% constraints from GMPR definition
function [consLeft, consRight, def_constraints_eq] = gmpr_op_get_def_constraints(thetaIndx, thetas, m, Pi)

[consLeft, consRight] = get_def_constraints_ineq(m, Pi);
def_constraints_eq = get_def_constraints_eq(thetaIndx, thetas, m);

end




function def_constraints_eq = get_def_constraints_eq(thetaIndx, thetas, m)

def_constraints_eq = [];

for k = (thetaIndx+1):m
    cur_constraint = strcat('-thetas(', int2str(k), ')+', num2str(thetas(k)), '; ');
    def_constraints_eq = strcat(def_constraints_eq, cur_constraint);
end

end




function [defConsLeft, defConsRight] = get_def_constraints_ineq(m, Pi)

lcons1 = zeros(m,m);

for consItr = 1:m
    
    if consItr == 1
        lcons1(1,1) = -1;
    else
        lcons1(consItr, consItr-1) = 1;
        lcons1(consItr, consItr) = -1;
    end
end


lcons2 = zeros(m,m);
for consItr = 1:m
    
    if consItr == 1
        lcons2(consItr, 1) = 1;
    elseif consItr == 2
        lcons2(consItr, 1) = -2;
        lcons2(consItr, 2) = 1;
    else
        lcons2(consItr, consItr-2) = 1;
        lcons2(consItr, consItr-1) = -2;
        lcons2(consItr, consItr) = 1;
    end
end

defConsLeft = [lcons1;lcons2];
defConsRight = zeros(1,2*m); defConsRight(1,m+1) = Pi;

end