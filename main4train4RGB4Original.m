clear,clc
addpath('liblinear/matlab');
parent_dir = 'DI4caffe/train/';
Norm4S_dir1 = [parent_dir,'FullbodyDif/'];
if ~exist(Norm4S_dir1)
    mkdir(Norm4S_dir1);
end
Norm4S_dir2 = [parent_dir,'FullbodyDir/'];
if ~exist(Norm4S_dir2)
    mkdir(Norm4S_dir2);
end


fpn = fopen('video/train_rgb.txt');           %打开文档clear,clc

ftrain = fopen('DI4caffe/train/train_rgb.txt','w');  %Genarate the training list for caffe
fval = fopen('DI4caffe/train/val_rgb.txt','w');   %Generate the validation list for caffe

while feof(fpn) ~= 1                 %用于判断文件指针p在其所指的文件中的位置，如果到文件末，函数返回1，否则返回0  
      file = fgetl(fpn);           %获取文档第一行  
      obj_origin = VideoReader(['video/',file(1:17),'.avi']);
      disp(['Processing DIs of ',file(11:17)]);
      numFrames_origin = obj_origin.NumberOfFrames;
      wd = obj_origin.Width;
      ht = obj_origin.Height;
          
      depth_final = zeros(ht,wd,3,numFrames_origin);
      
      for t = 1:numFrames_origin
          depthmap_origin = read(obj_origin, t);
          
          depth_final(:,:,:,t) = depthmap_origin;
      end
      
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
