% Run the daltonize function
daltonize('test.jpg'); % Default transformations

% Extract the file name without extension
[~, name, ext] = fileparts('test.jpg');

% Load the transformed images
RGB_p = imread([name '_p' ext]);
RGB_d = imread([name '_d' ext]);
RGB_t = imread([name '_t' ext]);
BW = imread([name '_bw' ext]);
