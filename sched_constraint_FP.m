function value = sched_constraint_FP(task, k, thetas, Pi)

value = (k*task.C + task.Wfp) - get_gmpr_psf_k(k, thetas, task.D, Pi);

end