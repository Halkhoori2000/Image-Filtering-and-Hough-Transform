function [img1] = myEdgeFilter(img0, sigma)
    % Compute the filter 
    h = fspecial('gaussian', 2 * ceil(3 * sigma) + 1, sigma);
    img1 = myImageFilter(img0, h); 

    h_sobel = fspecial('sobel');
    imgx = myImageFilter(img1, h_sobel);
    imgy = myImageFilter(img1, h_sobel');

    imgg = sqrt(imgx .* imgx + imgy .* imgy);
    imga = atan2(-imgy, imgx);

    % Apply NMS here 
    nms_0 = [0 0 0; 1 0 1; 0 0 0];
    nms_135 = [0 0 1; 0 0 0; 1 0 0];
    nms_90 = [0 1 0; 0 0 0; 0 1 0];
    nms_45 = [1 0 0; 0 0 0; 0 0 1];
    
    % Pad the gradient here 
    shape = size(imgg);
    imgg_pad = zeros(2 + shape(1), 2 + shape(2));
    imgg_pad(2 : 1 + shape(1), 2 : 1 + shape(2)) = imgg;
    
    % Make a copy of the gradient magnitude 
    img1 = imgg;
    
    for i = 1 : shape(1)
        for j = 1 : shape(2)
            w = imgg_pad(i : i + 2, j : j + 2);
            
            % Round off gradient 
            angle = round(imga(i, j) / (pi / 4)) * 45;
            
            if angle < 0
                angle = angle + 180;
            end
            
            % Check the 0 degree gradient
            if angle == 0
                if max(max(w .* nms_0)) > imgg(i, j)
                    img1(i, j) = 0;
                end 
            
            % Check the 45 degree gradient
            elseif imga(i, j) == 45
                if max(max(w .* nms_45)) > imgg(i, j)
                    img1(i, j) = 0;
                end 
            
            % Check the 90 degree gradient
            elseif imga(i, j) == 90
                if max(max(w .* nms_90)) > imgg(i, j)
                    img1(i, j) = 0;
                end 

            else 
                if max(max(w .* nms_135)) > imgg(i, j)
                    img1(i, j) = 0;
                end 
            end
        end
    end
end
    
                
        
        
