function outputImg = applyColorMatrix(img, matrix)
    % Reshape image to apply transformation
    imgReshaped = reshape(img, [], 3);
    transformedReshaped = imgReshaped * matrix';
    outputImg = reshape(transformedReshaped, size(img));
end
