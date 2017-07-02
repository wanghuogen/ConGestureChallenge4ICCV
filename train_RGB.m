clear,clc
parent_dir = 'Image4LSTM/train/';
Norm4S_dir1 = [parent_dir,'train_rgb_fullbody/'];
if ~exist(Norm4S_dir1)
    mkdir(Norm4S_dir1);
end
Norm4S_dir2 = [parent_dir,'train_rgb_full/'];
if ~exist(Norm4S_dir2)
    mkdir(Norm4S_dir2);
end


fpn = fopen ('video/train_rgb.txt');
ff_train1 = fopen('Image4LSTM/train/train_rgb_fullbody.txt','w');
ff_val1 = fopen('Image4LSTM/train/val_rgb_fullbody.txt','w');
ff_train2 = fopen('Image4LSTM/train/train_rgb_full.txt','w');
ff_val2 = fopen('Image4LSTM/train/val_rgb_full.txt','w');

while feof(fpn) ~= 1                  
      file = fgetl(fpn);          
      obj_origin = VideoReader(['video/',file(1:17),'.avi']);
      disp(['Exract Frame of ',file(11:17)]);
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
      
      
      
      depth_final = zeros(ht,wd,3);
      outImageNamef = fullfile(Norm4S_dir1,file(7:9),file(11:17));
      outImageNamer = fullfile(Norm4S_dir2,file(7:9),file(11:17));
      if ~exist(fullfile(Norm4S_dir1,file(7:9),file(11:17)))
          mkdir(fullfile(Norm4S_dir1,file(7:9),file(11:17)));
      end
      if ~exist(fullfile(Norm4S_dir2,file(7:9),file(11:17)))
          mkdir(fullfile(Norm4S_dir2,file(7:9),file(11:17)));
      end
      for t = 1:numFrames_origin
          depthmap_origin = read(obj_origin, t);
          imageNamef = fullfile(outImageNamef,sprintf('%s.jpg',num2str(t,'%03d')));
          imageNamer = fullfile(outImageNamer,sprintf('%s.jpg',num2str(t,'%03d')));
          depth_final(min(row):max(row),min(col):max(col),:) = depthmap_origin(min(row):max(row),min(col):max(col),:);
          imwrite(depthmap_origin,imageNamef)
          imwrite(uint8(depth_final),imageNamer)
          depth_final = zeros(ht,wd,3);  
      end
        fprintf(ff_train1,[outImageNamef,' ',num2str(numFrames_origin),' ',file(7:9),'\n']);
        fprintf(ff_train2,[outImageNamer,' ',num2str(numFrames_origin),' ',file(7:9),'\n']);
        if mod(str2num(file(11:15)),3)==0
            fprintf(ff_val1,[outImageNamef,' ',num2str(numFrames_origin),' ',file(7:9),'\n']);
            fprintf(ff_val2,[outImageNamef,' ',num2str(numFrames_origin),' ',file(7:9),'\n']);
        end
      
end
fclose(ff_train1);
fclose(ff_val1);
fclose(ff_train2);
fclose(ff_val2);
fclose(fpn);