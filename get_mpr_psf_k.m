% Computes the psf k function of the MPR interface (Y_k(t))
function psfKValue = get_mpr_psf_k(k, m, theta, t, Pi)

t1 = 2*(Pi - (theta/m));
theta_k = (k/m)*theta;

psfKValue = floor(max(t-t1, 0)/Pi)*theta_k + min(theta_k, k*mod(max(t-t1, 0), Pi));
end