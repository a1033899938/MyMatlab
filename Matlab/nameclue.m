function [cluednames] = nameclue(mat,idx)
filename_splited_mat = evalin('base', 'filename_splited_mat');
for iNames = 1:1:length(mat)
    cluednames = strcat(cluednames,filename_splited_mat(mat(iNames),idx),'-');
end
return
end