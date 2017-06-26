% This code provided by Sina Darvishi
%% Step 0: split videos to frames.
% first step is to split every videos to frames that contains our features
% get_frames will split videos to train and test frames(images) that we can
% now process on them.after first run of get_frames function we can comment
% it in future so we can process faster.
fprintf('Splitting Videos to frames...\n')
% get_frames('D:\Sina\MATLAB\Projects\Video-Scene-Recognition\Data\videos\split.mat');
fprintf('Splitting Finished!!!\n')
%% Step 1: Set up parameters, vlfeat, category list, and image paths.

FEATURE = 'bag of sift';
CLASSIFIER = 'libsvm';

% set up paths to VLFeat functions.
% See http://www.vlfeat.org/matlab/matlab.html for VLFeat Matlab documentation
% This should work on 32 and 64 bit versions of Windows, MacOS, and Linux,
% you should change it to your location
run('D:/Sina/Downloads/Compressed/VLFEATROOT/toolbox/vl_setup')
%direction of svm-lib
cd D:\Sina\Downloads\Compressed\libsvm-322\matlab
make
%back to code directory
cd D:\Sina\MATLAB\Projects\Video-Scene-Recognition

data_path = './data/'; %change if you want to work with a network copy

%This is the list of categories / directories to use. The categories are
%somewhat sorted by similarity so that the confusion matrix looks more
%structured (indoor and then urban and then rural).
categories = {'ApplyEyeMakeup', 'Archery', 'BaseballPitch', 'CricketBowling', 'Diving', ...
    'Hammering', 'HammerThrow', 'HeadMassage', 'JumpRope', 'Kayaking', ...
    'PlayingFlute', 'RockClimbingIndoor', 'Rowing', 'TableTennisShot', 'WritingOnBoard'};

%This list of shortened category names is used later for visualization.
abbr_categories = {'Am', 'Ar', 'BP', 'CB', 'Di', 'Ha', 'HT', ...
    'HM', 'Ju', 'K', 'PF', 'Rl', 'Ro', 'TT', 'WO'};

%number of training examples per category to use. Max is 100. For
%simplicity, we assume this is the number of test cases per category, as
%well.
num_train_per_cat = 100;

%This function returns cell arrays containing the file path for each train
%and test image, as well as cell arrays with the label of each train and
%test image. By default all four of these arrays will be 1500x1 where each
%entry is a char array (or string).
fprintf('Getting paths and labels for all train and test data\n')
[train_image_paths, test_image_paths, train_labels, test_labels] = ...
    get_image_paths(data_path, categories, num_train_per_cat);
%   train_image_paths  1500x1   cell
%   test_image_paths   1500x1   cell
%   train_labels       1500x1   cell
%   test_labels        1500x1   cell

%% Step 2: Represent each image with the appropriate feature
% Each function to construct features should return an N x d matrix, where
% N is the number of paths passed to the function and d is the
% dimensionality of each image representation. See the starter code for
% each function for more details.

fprintf('Using %s representation for images\n', FEATURE)

% YOU CODE build_vocabulary.m
vocab_size = 611; %Larger values will work better (to a point) but be slower to compute
if ~exist(['vocab_size', num2str(vocab_size),'.mat'], 'file')
    fprintf('No existing visual word vocabulary found. Computing one from training images\n')
    vocab = build_vocabulary(train_image_paths, vocab_size);
    save(['vocab_size', num2str(vocab_size),'.mat'], 'vocab')
end
fprintf('here1\n')
% YOU CODE get_bags_of_sifts.m
if ~exist(['train_image_feats_size', num2str(vocab_size),'.mat'], 'file')
    train_image_feats = get_bags_of_sifts(train_image_paths, vocab_size);
    save(['train_image_feats_size', num2str(vocab_size), '.mat'], 'train_image_feats');
else
    load(['train_image_feats_size', num2str(vocab_size),'.mat']);
end
fprintf('here2\n')
if ~exist(['test_image_feats_size', num2str(vocab_size), '.mat'])
    test_image_feats  = get_bags_of_sifts(test_image_paths, vocab_size);
    save(['test_image_feats_size', num2str(vocab_size), '.mat'], 'test_image_feats');
else
    load(['test_image_feats_size', num2str(vocab_size), '.mat']);
end
fprintf('here3\n')


% If you want to avoid recomputing the features while debugging the
% classifiers, you can either 'save' and 'load' the features as is done
% with vocab.mat, or you can utilize Matlab's "code sections" functionality
% http://www.mathworks.com/help/matlab/matlab_prog/run-sections-of-programs.html

%% Step 3: Classify each test image by training and using the appropriate classifier
% Each function to classify test features will return an N x 1 cell array,
% where N is the number of test cases and each entry is a string indicating
% the predicted category for each test image. Each entry in
% 'predicted_categories' must be one of the 15 strings in 'categories',
% 'train_labels', and 'test_labels'. See the starter code for each function
% for more details.

fprintf('Using %s classifier to predict test set categories\n', CLASSIFIER)

predicted_categories = libsvm_classify(train_image_feats, train_labels, test_image_feats,test_labels);
save(['predicted_categories', '.mat'], 'predicted_categories');

%% Step 4: Build a confusion matrix and score the recognition system
% You do not need to code anything in this section. 

% If we wanted to evaluate our recognition method properly we would train
% and test on many random splits of the data. You are not required to do so
% for this project.

% This function will recreate results_webpage/index.html and various image
% thumbnails each time it is called. View the webpage to help interpret
% your classifier performance. Where is it making mistakes? Are the
% confusions reasonable?

create_results_webpage( train_image_paths, ...
                        test_image_paths, ...
                        train_labels, ...
                        test_labels, ...
                        categories, ...
                        abbr_categories, ...
                        predicted_categories);

% Interpreting your performance with 100 training examples per category:
%  accuracy  =   0 -> Your code is broken (probably not the classifier's
%                     fault! A classifier would have to be amazing to
%                     perform this badly).
%  accuracy ~= .07 -> Your performance is chance. Something is broken or
%                     you ran the starter code unchanged.
%  accuracy ~= .20 -> Rough performance with tiny images and nearest
%                     neighbor classifier. Performance goes up a few
%                     percentage points with K-NN instead of 1-NN.
%  accuracy ~= .20 -> Rough performance with tiny images and linear SVM
%                     classifier. The linear classifiers will have a lot of
%                     trouble trying to separate the classes and may be
%                     unstable (e.g. everything classified to one category)
%  accuracy ~= .50 -> Rough performance with bag of SIFT and nearest
%                     neighbor classifier. Can reach .60 with K-NN and
%                     different distance metrics.
%  accuracy ~= .60 -> You've gotten things roughly correct with bag of
%                     SIFT and a linear SVM classifier.
%  accuracy >= .70 -> You've also tuned your parameters well. E.g. number
%                     of clusters, SVM regularization, number of patches
%                     sampled when building vocabulary, size and step for
%                     dense SIFT features.
%  accuracy >= .80 -> You've added in spatial information somehow or you've
%                     added additional, complementary image features. This
%                     represents state of the art in Lazebnik et al 2006.
%  accuracy >= .85 -> You've done extremely well. This is the state of the
%                     art in the 2010 SUN database paper from fusing many 
%                     features. Don't trust this number unless you actually
%                     measure many random splits.
%  accuracy >= .90 -> You get to teach the class next year.
%  accuracy >= .96 -> You can beat a human at this task. This isn't a
%                     realistic number. Some accuracy calculation is broken
%                     or your classifier is cheating and seeing the test
%                     labels.
