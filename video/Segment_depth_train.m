clear
clc
fpn = fopen('../DATA/con_list/train.txt');
ff_train = fopen('train_depth.txt','w');
base_name = 0;
while feof(fpn)~=1
    file = fgetl(fpn);
    Textfile = textscan(file,'%s');
    [num_text,n] = size(Textfile{1});
    obj_depth = VideoReader(['../DATA/ConGD_phase1/train/',Textfile{1}{1},'.K.avi']);
    disp(['Generate Isolate videos of ',Textfile{1}{1},'.K.avi']);
    numframes = obj_depth.NumberofFrames;
    wd = obj_depth.Width;
    ht = obj_depth.height;
    for i = 2:num_text
        frames = regexp(Textfile{1}{i},',','split');
        frame = regexp(frames{2},':','split');
        if ~exist(['train/',num2str(str2num(frame{2})-1,'%03d')])
          mkdir(['train/',num2str(str2num(frame{2})-1,'%03d')]);
        end
        base_name = base_name + 1;
        aviobj = VideoWriter(['train/',num2str(str2num(frame{2})-1,'%03d'),'/',num2str(base_name,'%05d'),'.K.avi']);
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
        fprintf(ff_train,['train/',num2str(str2num(frame{2})-1,'%03d'),'/',num2str(base_name,'%05d'),'.K ',num2str(fnum),' ',num2str(str2num(frame{2})-1),'\n']);
    end
end
fclose(ff_train)
fclose(fpn)    
