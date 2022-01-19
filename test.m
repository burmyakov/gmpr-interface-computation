function test()

tasks = get_sample_taskset();
m = 4;
Pi = 20;
scheduler = 'GEDF';

mpr = compute_mpr(tasks, m, Pi, scheduler);
disp(mpr);

GmprOPSolver = 'active-set';
gmpr = compute_gmpr(tasks, m, Pi, scheduler, GmprOPSolver);

disp('resulted gmpr interface:');
disp(gmpr);

end