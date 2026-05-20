function [rhos, thetas] = myHoughLines(H, nLines)
    % Apply NMS
    shape = size(H);
    H_pad = zeros(2 + shape(1), 2 + shape(2));
    H_pad(2 : 1 + shape(1), 2 : 1 + shape(2)) = H;
    
    % nms filter
    nms = [1 1 1; 1 0 1; 1 1 1];
    
    Hcopy = H;
    
    for i = 1 : shape(1)
        for j = 1 : shape(2)
            w = H_pad(i : i + 2, j : j + 2);
            
            % Suppress the pixel if neighbors are larger 
            if H(i, j) < max(max(w .* nms))
                Hcopy(i, j) = 0;
            end
        end
    end
    
    H_flat = zeros(shape(1) * shape(2), 3);
    
    k = 1;
    for i = 1 : shape(1)
        for j = 1 : shape(2)
            H_flat(k,1) = Hcopy(i, j);
            H_flat(k,2) = i;
            H_flat(k,3) = j;
            k = k + 1;
        end
    end
    
    H_sorted = sortrows(H_flat, 'descend');
    
    rhos = H_sorted(1:nLines, 2);
    thetas = H_sorted(1:nLines, 3);
    
end
        