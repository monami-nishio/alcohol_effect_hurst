addpath('/Users/monaminishio/Downloads/nonfractal/m')
addpath(genpath('/Users/monaminishio/Downloads/wmtsa-matlab-0.2.6'))
lb = [-0.5,0];
ub = [1.5,10];

H_combined = readtable('Hurst_rat_alcohol.csv', "FileType","text");
%col457 = H_combined.H_combined157;
%col458 = H_combined.H_combined158;
%col459 = H_combined.H_combined159;
%IDs = strcat(string(col457), string(col458), string(col459));
%H_all = table2cell(H_combined(:, 1:size(H_combined, 2)-3));
%sub_all = table2cell(H_combined(:, size(H_combined, 2)-2));
%ses_all = table2cell(H_combined(:, size(H_combined, 2)-1));
%run_all = table2cell(H_combined(:, size(H_combined, 2)));
H_all = [];
sub_all = [];
ses_all = [];
run_all = [];
subjlist = dir('/Users/monaminishio/HOME8/DataDrive3/NishioM/rodent_alcohol/timeseries/*_timeseries.csv');
for n=1:length(subjlist)
    filename = subjlist(n).name; 
    parts = split(filename, '_');
    sub=parts{1}; 
    ses=parts{2}; 
    run=parts{3}; 
    ID = strcat(sub, ses, run);
    %if ~ismember(ID, IDs)
    disp(n/length(subjlist)*100)
    subpath = strcat(subjlist(n).folder, '/', subjlist(n).name);
    table = readtable(subpath);
    table(1, :) = [];
    for j = 1:width(table)
        if isa(table.(j)(1),'double') == 0
            table.(j) = table.(j-1);
        end
    end 
    ArrayTable = table2array(table);
    [H, nfcor, fcor] = bfn_mfin_ml(ArrayTable, 'filter', 'Haar', 'lb', lb, 'ub', ub);
    H_all = [H_all; num2cell(H)];
    sub_all = [sub_all; sub];
    ses_all = [ses_all; ses];
    run_all = [run_all; run];
    H_combined = [num2cell(H_all) cellstr(sub_all) cellstr(ses_all) cellstr(run_all)];
    H_combined = cell2table(H_combined);
    writetable(H_combined, 'Hurst_rat_alcohol.csv');
    %end
end
