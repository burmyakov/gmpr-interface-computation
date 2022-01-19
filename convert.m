function convert()

inFile = 'output/Varying_Umax_not_formatted.txt';
outFile = 'output/Varying_Umax_converted.txt';

results = dlmread(inFile);
results(:,13) = 1;

dlmwrite(outFile, results, '-append', 'delimiter', ' ', 'precision', 6, 'newline', 'pc');

end