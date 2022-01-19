function value = get_gmpr_psf_k(k, thetas, t, Pi)

if t > Pi
    yk_even = get_yk_even(k, thetas, t, Pi);
    yk_odd = get_yk_odd(k, thetas, t, Pi);
    value = min(yk_even, yk_odd);
else
    value = get_yk_even(k, thetas, t, Pi);
end

end




function value = get_yk_even(k, thetas, t, Pi)

p_even = 2*floor(t/(2*Pi));
r_even = (1/2)*(t - p_even*Pi);

sum = 0;
for itr = 1:k
    if itr == 1
        sum = sum + max(0, r_even - Pi + thetas(1));
    else
        sum = sum + max(0, r_even - Pi + thetas(itr) - thetas(itr-1));
    end
end

value = p_even*thetas(k) + 2*sum;

end



function value = get_yk_odd(k, thetas, t, Pi)

p_odd = max(0, 2*floor((t-Pi)/(2*Pi)))+1;
r_odd = (1/2)*(t - p_odd*Pi);

sum = 0;
for itr = 1:k
    if itr == 1
        sum = sum + max(0, r_odd - Pi + thetas(1));
    else
        sum = sum + max(0, r_odd - Pi + thetas(itr) - thetas(itr-1));
    end
end

value = p_odd*thetas(k) + 2*sum;

end