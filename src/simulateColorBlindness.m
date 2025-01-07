function outputImg = simulateColorBlindness(img, type)
    % Convert image to double precision for matrix operations
    img = im2double(img);

    % Convert RGB to LMS color space
    rgb2lms = [ 
        0.31399022, 0.63951294, 0.04649755;
        0.15537241, 0.75789446, 0.08670142;
        0.01775239, 0.10944209, 0.87256922];
    lmsImg = applyColorMatrix(img, rgb2lms);

    % Define transformation matrices for different types of color blindness
    switch type
        case 'protanopia'
            colorDeficiencyMatrix = [ 
                0.0, 1.05118294, -0.05116099;
                0.0, 1.0, 0.0;
                0.0, 0.0, 1.0 ];
        case 'deuteranopia'
            colorDeficiencyMatrix = [ 
                1.0, 0.0, 0.0;
                0.9513092, 0.0, 0.04866992;
                0.0, 0.0, 1.0 ];
        case 'tritanopia'
            colorDeficiencyMatrix = [ 
                1.0, 0.0, 0.0;
                0.0, 1.0, 0.0;
                -0.86744736, 1.86727089, 0.0 ];
        otherwise
            colorDeficiencyMatrix = eye(3);
    end

    % Apply color blindness simulation
    lmsDeficient = applyColorMatrix(lmsImg, colorDeficiencyMatrix);

    % Convert back to RGB color space
    lms2rgb = [ 
        5.47221206, -4.6419601,  0.16963708;
        -1.1252419,  2.29317094, -0.1678952;
        0.02980165, -0.19318073, 1.16364789];
    outputImg = applyColorMatrix(lmsDeficient, lms2rgb);

    % Clip values to valid range [0,1]
    outputImg = max(min(outputImg, 1), 0);
end