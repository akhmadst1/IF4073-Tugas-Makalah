%% Author: David de los Santos Boix <davsanboi@alum.us.es>
%% Keywords: daltonismo protanopia deuteranopia tritanopia
%% Maintainer: David de los Santos Boix <davsanboi@alum.us.es>
%% Created: 01/02/2017
%% Version: 1.0

%% usage: daltonize(IMAGE)
%%
%% Convert an ordinary image to protanopia, deuteranopia and tritanopia colorblind version.

function [RGB_p, RGB_d, RGB_t, BW] = daltonize(image_path)
    % Checking if the image exists...
    if exist(image_path, 'file') == 0
        error('The given image file does not exist');
    end

    % Checking if the image is colorized...
    image = imread(image_path);
    sizeRGB = size(image);

    % Getting its values for Black/White and colorblind transformation
    BW = rgb2gray(image);
    RGB = double(image);

    % Choosing the transformation matrices...
    rgb2xyz = get_rgb2xyz_matrix();
    xyz2lms = get_xyz2lms_matrix();

    % Calculate the necessary RGB to LMS and LMS to RGB matrices...
    rgb2lms = xyz2lms * rgb2xyz;
    lms2rgb = inv(rgb2lms);

    % Getting the LMS vectors configuration...
    lms_r = rgb2lms(1,:);
    lms_b = rgb2lms(3,:);
    lms_w = rgb2lms * ones(3, 1);

    % Applying the cross product to get the matrices...
    p0 = cross(lms_w, lms_b');
    p1 = cross(lms_w, lms_r');

    lms2lms_p = [  0.0000,       0.0000,  0.0000;
                  -p0(2)/p0(1),  1.0000,  0.0000;
                  -p0(3)/p0(1),  0.0000,  1.0000]';

    lms2lms_d = [  1.0000, -p0(1)/p0(2),  0.0000;
                    0.0000, 0.0000,  0.0000;
                    0.0000, -p0(3)/p0(2),  1.0000]';

    lms2lms_t = [ 1.0000,  0.0000, -p1(1)/p1(3);
                  0.0000, 1.0000, -p1(2)/p1(3);
                  0.0000, 0.0000,      0.0000]';

    % Getting the colorblind images....
    RGB_p = get_colorblind_image(RGB, rgb2lms, lms2lms_p);
    RGB_d = get_colorblind_image(RGB, rgb2lms, lms2lms_d);
    RGB_t = get_colorblind_image(RGB, rgb2lms, lms2lms_t);

    % Formatting images to uint8...
    RGB_p = uint8(RGB_p);
    RGB_d = uint8(RGB_d);
    RGB_t = uint8(RGB_t);
end

function RGB = get_colorblind_image(im, rgb2lms_matrix, colorblind_matrix)
  % First separate the RGB channels
  R = im(:,:,1);
  G = im(:,:,2);
  B = im(:,:,3);

  % Convert from RGB to LMS. The order is switched, so we have to transpose
  lms_image =  double([R(:), G(:), B(:)]) * rgb2lms_matrix';
  
  % Apply the colorblind matrix. Again, switched order, transposed matrix
  lms_cb = lms_image * colorblind_matrix';
  
  % Revert to RGB by inverting the rgb2lms_matrix
  RGB = lms_cb * inv(rgb2lms_matrix)' ;
  
  % Finally, reshape the image to its size
  RGB = reshape(RGB, size(im));  
end

%http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
function rgb2xyz = get_rgb2xyz_matrix()
  rgb2xyz = [ 0.7161046  0.1009296  0.1471858;
              0.2581874  0.7249378  0.0168748;
              0.0000000  0.0517813  0.7734287];
end

%https://en.wikipedia.org/wiki/LMS_color_space#XYZ_to_LMS
function xyz2lms = get_xyz2lms_matrix()
    xyz2lms = [ 0.7328 0.4296 -0.1624;
                -0.7036 1.6975  0.0061;
                0.0030 0.0136  0.9834];
end