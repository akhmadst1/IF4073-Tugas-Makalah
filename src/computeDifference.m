function diffImg = computeDifference(originalImg, enhancedImg)
    % Compute absolute difference
    diffImg = abs(originalImg - enhancedImg);
    
    % Enhance visibility by amplifying the difference
    scaleFactor = 5; % Adjust this for better visualization
    diffImg = diffImg * scaleFactor;
    
    % Clip values to valid range [0,1]
    diffImg = max(min(diffImg, 1), 0);
end
