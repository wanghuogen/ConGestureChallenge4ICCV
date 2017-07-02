clear,clc
addpath('liblinear/matlab');
parent_dir = 'DI4caffe/train/';  %Please change your parent_dir to your own folder
Norm4S_dir1 = [parent_dir,'FullDif/'];
if ~exist(Norm4S_dir1)
    mkdir(Norm4S_dir1);
end
Norm4S_dir2 = [parent_dir,'FullDir/'];
if ~exist(Norm4S_dir2)
    mkdir(Norm4S_dir2);
end

fpn = fopen ('video/train_rgb.txt');


ftrain = fopen('DI4caffe/train/train_rgb.txt','w');  %Genarate the training list for caffe
fval = fopen('DI4caffe/train/val_rgb.txt','w');   %Generate the validation list for caffe

while feof(fpn) ~= 1                
      file = fgetl(fpn);           
      obj_origin = VideoReader(['video/',file(1:17),'.avi']);
      disp(['Processing DIs of ',file(11:17)]);
      detectionLabel = fopen(['DATA/train_Rgb_DetectionLabel/',file(7:9),'/Label_',file(11:17),'.txt']);
      numFrames_origin = obj_origin.NumberOfFrames;
      wd = obj_origin.Width;
      ht = obj_origin.Height;
      
      hand_area = zeros(ht,wd,3);
      
      l = 1;
      while feof(detectionLabel) ~= 1
          label_file = fgetl(detectionLabel);
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
      stats = regionprops(LL,'Area');     
      area = cat(1,stats.Area);  
      index = find(area >0.5*max(area));        
      img_hand = ismember(LL,index);         
      [row, col] = find( img_hand ~= 0 );
      
      
      
      depth_final = zeros(ht,wd,3,numFrames_origin);
      
      for t = 1:numFrames_origin
          depthmap_origin = read(obj_origin, t);
          depth_final(min(row):max(row),min(col):max(col),:,t) = depthmap_origin(min(row):max(row),min(col):max(col),:);
      end
      hand_area_final = img_hand(min(row):max(row),min(col):max(col));
      
      outImageNamef = fullfile(Norm4S_dir1,file(7:9),sprintf('%s.jpg',file(11:17)));
      outImageNamer = fullfile(Norm4S_dir2,file(7:9),sprintf('%s.jpg',file(11:17)));

      
      if ~exist(fullfile(Norm4S_dir1,file(7:9)))
          mkdir(fullfile(Norm4S_dir1,file(7:9)));
      end
      if ~exist(fullfile(Norm4S_dir2,file(7:9)))
          mkdir(fullfile(Norm4S_dir2,file(7:9)));
      end

      depth_final = uint8(depth_final);
      [zWF,zWR] = GetDynamicImages4(depth_final);
      imwrite(zWF(:,:,:,1),outImageNamef,'jpg');
      imwrite(zWR(:,:,:,1),outImageNamer,'jpg');

      fprintf(ftrain,'%s %s\n',fullfile(file(7:9),sprintf('%s.jpg',file(11:17))),file(7:9));
      if mod(str2num(file(11:15)),3) == 0
          fprintf(fval,'%s %s\n',fullfile(file(7:9),sprintf('%s.jpg',file(11:17))),file(7:9));
      end
      
end
fclose(fpn);
fclose(ftrain);
fclose(fval);
