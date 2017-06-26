% Code prepared by Sina Darvishi

%This function returns cell arrays containing the file path for each train
%and test image, as well as cell arrays with the label of each train and
%test image. By default all four of these arrays will be 1500x1 where each
%entry is a char array (or string).
function [train_image_paths, test_image_paths, train_labels, test_labels] = ... 
    get_image_paths(data_path, categories)

num_categories = length(categories); %number of scene categories.

train_buff = 1568;
test_buff = 611;
%This paths for each training and test image. By default it will have 1500
%entries (15 categories * 100 training and test examples each)
train_image_paths = cell(train_buff,1);%num_categories * num_train_per_cat, 1);
test_image_paths  = cell(test_buff,1);%num_categories * num_train_per_cat, 1);

%The name of the category for each training and test image. With the
%default setup, these arrays will actually be the same, but they are built
%independently for clarity and ease of modification.
train_labels = cell(train_buff,1);%num_categories * num_train_per_cat, 1);
test_labels  = cell(test_buff,1);%num_categories * num_train_per_cat, 1);

numTrain = 0;
numTest = 0;
for i=1:num_categories
   images = dir( fullfile(data_path, 'train', categories{i}, '*.jpg'));
   for j=1:length(images)
       train_image_paths{numTrain + j} = fullfile(data_path, 'train', categories{i}, images(j).name);
       train_labels{numTrain + j} = categories{i};
   end
   numTrain = numTrain + length(images);
   
   images = dir( fullfile(data_path, 'test', categories{i}, '*.jpg'));
   for j=1:length(images)
       test_image_paths{numTest + j} = fullfile(data_path, 'test', categories{i}, images(j).name);
       test_labels{numTest + j} = categories{i};
   end
   numTest = numTest + length(images);
end

save(['test_image_paths','.mat'], 'test_image_paths')
save(['train_image_paths','.mat'], 'train_image_paths')


fprintf('train path finished\n')
