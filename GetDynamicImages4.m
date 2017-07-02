% 
% *********************************************************
% Visual darwin code for generating dynamic images.
% ********************************************************* 
% 
% 
% Original dynamic image paper based on VideoDarwin is explained here
% http://arxiv.org/abs/1512.01848
%
% Rank Pooling for Action Recognition, Basura Fernando, Efstratios Gavves, 
% Jose Oramas, Amir Ghodrati, Tinne Tuytelaars, TPAMI 2016
% 
% 
% CNN version of Dynamic Images with approximate rank pooling is explained
% here.
%
% Dynamic Image Networks for Action Recognition, Hakan Bilen, Basura Fernando, 
% Efstratios Gavves, Andrea Vedaldi and Stephen Gould, CVPR 2016 
% 
% 
% 
% 
% ************************************************************************
% Author : Basura Fernando
% This code is based on VideoDarwin code available at https://bitbucket.org/bfernando/videodarwin
% Contact basura.fernando@anu.edu.au
% *************************************************************************
% 
%***********************
% LICENSE & TERMS OF USE
% **********************
% VideoDarwin code implements a sequence representation technique. 
% Copyright (C) 2016 Basura Fernando
% Terms of Use
% 
% This VideoDarwin software is strictly for non-commercial academic use only. 
% This VideoDarwin code or any modified version of it may not be used for 
% any commercial activity, such as: 1. Commercial production development, 
% Commercial production design, design validation or design assessment work. 
% 2. Commercial manufacturing engineering work 3. Commercial research. 4. 
% Consulting work performed by academic students, faculty or academic account staff 
% 5. Training of commercial company employees.
% License
% 
% The analysis work performed with the program(s) must be non-proprietary work. 
% Licensee and its contract users must be or be affiliated with an academic 
% facility. Licensee may additionally permit individuals who are students 
% at such academic facility to access and use the program(s). Such students 
% will be considered contract users of licensee. The program(s) may not be 
% used for commercial competitive analysis (such as benchmarking) or for 
% any commercial activity, including consulting.
%
% **************************** END ***************************************

% VideoName : full video name/path
% Need liblinear package to generate dynamic images.
 

function [zWF,zWR] = GetDynamicImages3(x)
    [w,h,~,len] = size(x);
    x = reshape(x,h*w*3,len);x =x';        
    Window_Size = len; 
    stride = 1;
    if len > Window_Size
        sStart = 1:stride:len-Window_Size+1;
        sEnd = Window_Size:stride:len;
        sEnd(end) = len;
    else
        sStart = 1;
        zWF = len;
        sEnd = len;
    end    
    segments = numel(sStart);    
    % pick only the middle segments
    if segments > 6
        sStart = sStart(round(segments/2)-3:round(segments/2)+2);
        sEnd = sEnd(round(segments/2)-3:round(segments/2)+2);
        segments = numel(sStart);    
    end
    zWF = zeros(w,h,3,segments,'uint8');zWR = zWF;
    for s = 1 : segments
        st = sStart(s);
        send = sEnd(s);
        [im_WF,im_WR] = processVideo(x(st:send,:),w,h);
        im_WF = linearMapping(im_WF);
        im_WR = linearMapping(im_WR);
        zWF(:,:,:,s)  = im_WF;
        zWR(:,:,:,s)  = im_WR;
    end    
end

function [im_WF,im_WR] = processVideo(x,w,h)
    [WF,WR] = genRankPoolImageRepresentation(single(x),10);    
     im_WF = reshape(WF,w,h,3);
     im_WR = reshape(WR,w,h,3);    
end

function [W_fow,W_rev] = genRankPoolImageRepresentation(data,CVAL)
    OneToN = [1:size(data,1)]';    
    Data = cumsum(data);
    Data = Data ./ repmat(OneToN,1,size(Data,2));
    W_fow = liblinearsvr(getNonLinearity(Data,'ssr'),CVAL,2); clear Data; 			
    order = 1:size(data,1);
    [~,order] = sort(order,'descend');
    data = data(order,:);
    Data = cumsum(data);
    Data = Data ./ repmat(OneToN,1,size(Data,2));
    W_rev = liblinearsvr(getNonLinearity(Data,'ssr'),CVAL,2); 			                  
end

function w = liblinearsvr(Data,C,normD)
    if normD == 2
        Data = normalizeL2(Data);
    end    
    if normD == 1
        Data = normalizeL1(Data);
    end    
    N = size(Data,1);
    Labels = [1:N]';
    model = train(double(Labels), sparse(double(Data)),sprintf('-c %1.6f -s 11 -q',C) );
    w = model.w';    
end

function Data = getNonLinearity(Data,nonLin)    
    switch nonLin            
        case 'ssr'
            Data = sign(Data).*sqrt(abs(Data));       
    end
end

function x = normalizeL2(x)
    v = sqrt(sum(x.*conj(x),2));
    v(find(v==0))=1;
    x=x./repmat(v,1,size(x,2));
end

function x = linearMapping(x)
    minV = min(x(:));
    maxV = max(x(:));
    x = x - minV;
    x = x ./ (maxV - minV);
    x = x .* 255;
    x = uint8(x);
end
