function xlabels = get_xlabels(values)

xlabels = cell(1,numel(values));

for itr = 1:numel(values)
    if mod(itr,2) == 1
        xlabels{1,itr} = num2str(values(itr));
    else
        xlabels{1,itr} = ' ';
    end
end

end