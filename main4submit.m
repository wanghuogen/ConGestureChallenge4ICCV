clear all;
clc;
%% set path

list_file_seg_path = 'test_segmented.list';



segData=importdata(list_file_seg_path);
[name_list] = textread(list_file_seg_path, '%s %*[^\n]');



finId = fopen('test_p.txt','r');
foutId = fopen('test_prediction.txt','w');

for i = 1:length(name_list)
    tic;
    
    TotalSegNoChar=sprintf('%d',length(name_list));
    iChar=sprintf('%d',i);
    disp(['Processing DMMs of ', name_list{i},':->',iChar,'/',TotalSegNoChar]);
    TempSegFile = regexp(segData{i}, ' ', 'split');
    segNo=size(TempSegFile,2);

    fprintf(foutId,'%s ',TempSegFile{1});

    for j=2:segNo
        tline = fgetl(finId);
        tempNode=[TempSegFile{j}(1:end-1),tline]
        if j < segNo
           fprintf(foutId,'%s ',tempNode);
        end
        if j == segNo
            fprintf(foutId,'%s',tempNode);
        end
       
    end
    fprintf(foutId,'\n');
end
fclose(finId);
fclose(foutId);



