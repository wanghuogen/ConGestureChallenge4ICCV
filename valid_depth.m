clear,clc
parent_dir = 'Image4LSTM/valid/';
Norm4S_dir1 = [parent_dir,'valid_depth_fullbody/'];
if ~exist(Norm4S_dir1)
    mkdir(Norm4S_dir1);
end
Norm4S_dir2 = [parent_dir,'valid_depth_full/'];
if ~exist(Norm4S_dir2)
    mkdir(Norm4S_dir2);
end


fpn = fopen ('video/valid_seg_depth.txt');           %打开文档clear,clc

ff_train1 = fopen('Image4LSTM/valid/valid_depth_fullbody.txt','w');
ff_train2 = fopen('Image4LSTM/valid/valid_depth_full.txt','w');

%ff_val = fopen('val.txt','w');
while feof(fpn) ~= 1                %用于判断文件指针p在其所指的文件中的位置，如果到文件末，函数返回1，否则返回0  
      file = fgetl(fpn);           %获取文档第一行  
      obj_origin = VideoReader(['video/',file(1:17),'.avi']);
      detectionLabel = fopen(['DATA/valid_seg_Depth_DetectionLabel/Label_',file(11:17),'.txt']);
      disp(['Exract Frame of ',file(11:17)]);
      numFrames_origin = obj_origin.NumberOfFrames;
      wd = obj_origin.Width;
      ht = obj_origin.Height;
      
      hand_area = zeros(ht,wd,3);
      
      l = 1;
      while feof(detectionLabel) ~= 1
          label_file = fgetl(detectionLabel);           %获取文档第一行
          if label_file ~= -1
            numFrame = str2num(label_file(1:4))+1;
            TextFile = textscan(label_file,'%s');
            [m,n] = size(TextFile{1});
            k = (m-1)/4;
            for i = 1:k
                hand_area(str2num(TextFile{1}{4*i-1})+1:str2num(TextFile{1}{4*i+1})+1,str2num(TextFile{1}{4*i-2})+1:str2num(TextFile{1}{4*i})+1,:) = 255;
            end
          else
            hand_area = 255 * ones(ht,wd,3);
          end
      end
      fclose(detectionLabel);
      
      hand_area = im2bw(hand_area);
      [LL,num_L] = bwlabel(hand_area);
      stats = regionprops(LL,'Area');    %求各连通域的大小  
      area = cat(1,stats.Area);  
      index = find(area >0.5*max(area));        %求最大连通域的索引  
      img_hand = ismember(LL,index);          %获取最大连通域图像  
      [row, col] = find( img_hand ~= 0 );
      
      
      
      depth_final = zeros(ht,wd,3);
      outImageNamef = fullfile(Norm4S_dir1,file(11:17));
      outImageNamer = fullfile(Norm4S_dir2,file(11:17));
      if ~exist(fullfile(Norm4S_dir1,file(11:17)))
          mkdir(fullfile(Norm4S_dir1,file(11:17)));
      end
      if ~exist(fullfile(Norm4S_dir2,file(11:17)))
          mkdir(fullfile(Norm4S_dir2,file(11:17)));
      end
      for t = 1:numFrames_origin
          depthmap_origin = read(obj_origin, t);
          imageNamef = fullfile(outImageNamef,sprintf('%s.jpg',num2str(t,'%03d')));
          imageNamer = fullfile(outImageNamer,sprintf('%s.jpg',num2str(t,'%03d')));
          depth_final(min(row):max(row),min(col):max(col),:) = depthmap_origin(min(row):max(row),min(col):max(col),:);
          imwrite(depthmap_origin,imageNamef);
          imwrite(uint8(depth_final),imageNamer);
          depth_final = zeros(ht,wd,3);
      end

        fprintf(ff_train1,[outImageNamef,' ',num2str(numFrames_origin),' 0\n']);
        fprintf(ff_train2,[outImageNamer,' ',num2str(numFrames_origin),' 0\n']);
end
fclose(ff_train1);
fclose(ff_train2);
fclose(fpn);