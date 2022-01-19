function value = sched_constraint_EDF(task, k, thetas, Pi)

value = (k*task.C + task.Wedf) - get_gmpr_psf_k(k, thetas, task.D, Pi);

end