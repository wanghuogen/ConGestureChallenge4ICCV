clear
clc
fpn = fopen('../valid_segmented.list');
ff_valid_filename = fopen('valid_seg_rgb.txt','w');

base_name = 0;
while feof(fpn)~=1
    file = fgetl(fpn);
    Textfile = textscan(file,'%s');
    [num_text,n] = size(Textfile{1});
    obj_depth = VideoReader(['../DATA/ConGD_phase1/valid/',Textfile{1}{1},'.M.avi']);
    disp(['Generate Isolate videos of ',Textfile{1}{1},'.M.avi']);
    numframes = obj_depth.NumberofFrames;
    wd = obj_depth.Width;
    ht = obj_depth.height;
    for i = 2:num_text
        frames = regexp(Textfile{1}{i},',','split');
        frame = regexp(frames{2},':','split');
        base_name = base_name + 1;
        if ~exist('valid_seg')
          mkdir('valid_seg');
        end
        aviobj = VideoWriter(['valid_seg/',num2str(base_name,'%05d'),'.M.avi']);
        aviobj.FrameRate = obj_depth.FrameRate;
        open(aviobj);
        img_num = 1;
        for f = str2num(frames{1}):str2num(frame{1})
            %figure(1),imshow(read(obj_depth,f))
            writeVideo(aviobj,uint8(read(obj_depth,f)));
            %imwrite(uint8(read(obj_depth,f)),['train_img/',num2str(str2num(frame{2})-1,'%03d'),'/',file(5:9),'.K/',num2str(img_num,'%06d'),'.jpg']);
            img_num = img_num + 1;
        end
        close(aviobj);
        fnum = str2num(frame{1})-str2num(frames{1})+1;
        fprintf(ff_valid_filename,['valid_seg/',num2str(base_name,'%05d'),'.M ',num2str(fnum),' ',frame{2},'\n']);
    end
end
fclose(ff_valid_filename)
fclose(fpn)
