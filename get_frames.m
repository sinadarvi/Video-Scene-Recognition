% Code prepared by Sina Darvishi

%   GET_FRAMES will split videos to frames
%   will get just a pat to split file in your Data directory.your directory
%   should have 3 directory in it self."videos","train","test".
function  get_frames( raw_video_path )

% first we split test videos
fprintf('Splitting test videos...\n')
split = load(raw_video_path);
for i= 1:length(split.test)
    video_path = split.test{i,1};
    if(i > 1)
        %before spliting a video we should check that if it is a new
        %category or not,if yes we will make new directory if not we
        %continue.no need to create direcories
        if((split.test{i,2} ~= split.test{i-1,2}))
            dir = extractBefore(split.test{i,1},'/')
            newDir = strcat('D:\Sina\MATLAB\Projects\Video-Scene-Recognition\Data\test\',dir);
            mkdir(char(newDir))
        end
    else 
        dir = extractBefore(split.test{i,1},'/')
        newDir = strcat('D:\Sina\MATLAB\Projects\Video-Scene-Recognition\Data\test\',dir);
        mkdir(char(newDir))
    end
    a=VideoReader(char(strcat('Data/videos/',video_path)))
    %every 30 frame we capture one frame
%     for img = 1:120:a.NumberOfFrames;
%         filename=char(strcat('f_',erase(extractAfter(a.Name,'v_'),'.avi'),'_',num2str(img),'.jpg'));
%         b = read(a, img);
%         newFileName = char(strcat('Data/test/' ,extractBefore(extractAfter(a.Name,'v_'),'_'),'/', filename));
%         imwrite(b,newFileName);
%     end
    filename=char(strcat('f_',erase(extractAfter(a.Name,'v_'),'.avi'),'.jpg'));
    b = rgb2gray(read(a, 30));
    newFileName = char(strcat('Data/test/' ,extractBefore(extractAfter(a.Name,'v_'),'_'),'/', filename));
        imwrite(b,newFileName);
end

% first we split test videos
fprintf('Splitting test videos...\n')
split = load(raw_video_path);
for i= 1:length(split.train)
    video_path = split.train{i,1};
    if(i > 1)
        if((split.train{i,2} ~= split.train{i-1,2}))
            dir = extractBefore(split.train{i,1},'/')
            newDir = strcat('D:\Sina\MATLAB\Projects\Video-Scene-Recognition\Data\train\',dir);
            mkdir(char(newDir))
        end
    else 
        dir = extractBefore(split.train{i,1},'/')
        newDir = strcat('D:\Sina\MATLAB\Projects\Video-Scene-Recognition\Data\train\',dir);
        mkdir(char(newDir))
    end
    a=VideoReader(char(strcat('Data/videos/',video_path)))
%     for img = 1:120:a.NumberOfFrames;
%         filename=char(strcat('f_',erase(extractAfter(a.Name,'v_'),'.avi'),'_',num2str(img),'.jpg'));
%         b = read(a, img);
%         newFileName = char(strcat('Data/train/' ,extractBefore(extractAfter(a.Name,'v_'),'_'),'/', filename));
%         imwrite(b,newFileName);
%     end
    filename=char(strcat('f_',erase(extractAfter(a.Name,'v_'),'.avi'),'.jpg'));
    b = rgb2gray(read(a, 30));
    newFileName = char(strcat('Data/train/' ,extractBefore(extractAfter(a.Name,'v_'),'_'),'/', filename));
    imwrite(b,newFileName);
end


end

