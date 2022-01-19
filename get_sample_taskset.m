function tasks = get_sample_taskset()

tasks = struct('C', {}, 'T', {}, 'D', {}, 'Wedf', {}, 'Wfp', {}, 'P', {}, 'kBarEdf', {}, 'kBarFp', {});

tasks(1).C = 5;       tasks(1).T = 60;    tasks(1).D = tasks(1).T;
tasks(2).C = 5;      tasks(2).T = 100;    tasks(2).D = tasks(2).T;
tasks(3).C = 9;      tasks(3).T = 60;    tasks(3).D = tasks(3).T;

%tasks(3).C = 29;      tasks(3).T = 60;    tasks(3).D = tasks(3).T;
%tasks(4).C = 27;      tasks(4).T = 70;    tasks(4).D = tasks(4).T;
%tasks(5).C = 17;      tasks(5).T = 80;    tasks(5).D = tasks(5).T;
%tasks(6).C = 1.3515;        tasks(6).T = 90;    tasks(6).D = tasks(6).T;
%tasks(7).C = 11.1931;        tasks(7).T = 107;    tasks(7).D = tasks(7).T;
%tasks(8).C = 60.8302;        tasks(8).T = 130;    tasks(8).D = tasks(8).T;
%tasks(9).C = 59.2295;    tasks(9).T = 165;    tasks(9).D = tasks(9).T;
%tasks(10).C = 66.1606; tasks(10).T = 168;   tasks(10).D = tasks(10).T;
%tasks(11).C = 2.1695;   tasks(11).T = 187;   tasks(11).D = tasks(11).T;

% two tasks test
%tasks(1).C = 11.5768;       tasks(1).T = 29;    tasks(1).D = tasks(1).T;
%tasks(2).C = 22.8607;      tasks(2).T = 76;    tasks(2).D = tasks(2).T;


%tasks(3).C = 15.1953;      tasks(3).T = 41;    tasks(3).D = tasks(3).T;
%tasks(4).C = 16.7476;          tasks(4).T = 55;    tasks(4).D = tasks(4).T;
%tasks(5).C = 19.185;        tasks(5).T = 55;    tasks(5).D = tasks(5).T;
%tasks(6).C = 6.3016;        tasks(6).T = 61;    tasks(6).D = tasks(6).T;
% tasks(7).C = 2695.1;        tasks(7).T = 5148;    tasks(7).D = tasks(7).T;
% tasks(8).C = 5056.5;        tasks(8).T = 8940;    tasks(8).D = tasks(8).T;
% tasks(9).C = 3682.4;    tasks(9).T = 11103;    tasks(9).D = tasks(9).T;
% tasks(10).C = 595.3344; tasks(10).T = 13274;   tasks(10).D = tasks(10).T;
% tasks(11).C = 3847.4;   tasks(11).T = 13576;   tasks(11).D = tasks(11).T;
% tasks(12).C = 5469;     tasks(12).T = 13809;   tasks(12).D = tasks(12).T;
% tasks(13).C = 6785.4;   tasks(13).T = 15478;   tasks(13).D = tasks(13).T;
% tasks(14).C = 2789.8;   tasks(14).T = 15518;   tasks(14).D = tasks(14).T;
% tasks(15).C = 2665.3;   tasks(15).T = 15886;   tasks(15).D = tasks(15).T;
% tasks(16).C = 3112.8;   tasks(16).T = 16027;   tasks(16).D = tasks(16).T;
% tasks(17).C = 4436.1;   tasks(17).T = 16126;   tasks(17).D = tasks(17).T;
% tasks(18).C = 7760.3;   tasks(18).T = 18381;   tasks(18).D = tasks(18).T;

tasks = compute_Ws(tasks);

for i = 1:numel(tasks)
    [tasks(i).kBarEdf,tasks(i).kBarFp] = compute_kBar(tasks(i));
end

% display the results
%for i = 1:numel(tasks)
    %disp(['Wedf:' num2str(tasks(i).Wedf)]);
    %disp(['Wfp:' num2str(tasks(i).Wfp)]);
    %disp(['kBarEdf:' num2str(tasks(i).kBarEdf)]);
%end

end