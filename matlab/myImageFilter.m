function [img1] = myImageFilter(img0, kernel)
    shape = size(img0);
    kernel_shape = size(kernel);
    img1 = zeros(shape(1), shape(2));
    %kernel_sum = 1; %sum(sum(double(kernel)));
    
    % Kernel should have odd dimensions
    if mod(kernel_shape(1), 2) == 0
        return  
    end
    
    if mod(kernel_shape(2), 2) == 0
        return  
    end
    
    % Compute the padding 
    row_padding = (kernel_shape(1) - 1) / 2;
    col_padding = (kernel_shape(2) - 1) / 2;
    
    % Create the image matrix with padding 
    img0_pad = zeros(shape(1) + 2 * row_padding, shape(2) + 2 * col_padding);
    img0_pad(row_padding + 1 : row_padding + shape(1), col_padding + 1 : col_padding + shape(2)) = double(img0);
    
    % For each pixel, compute the convulation
    for i = 1 : shape(1)
        for j = 1 : shape(2)
            w = img0_pad(i : i - 1 + kernel_shape(1), j : j - 1 + kernel_shape(2));
            img1(i, j) = sum(sum((w .* double(kernel))));
        end
    end
    
end
