function [H, rhoScale, thetaScale] = myHoughTransform(Im, threshold, rhoRes, thetaRes)
    % Create the range for rho and theta
    shape = size(Im);
    M = sqrt(sum(shape .* shape));
    rhoScale = 0 : rhoRes : M;
    thetaScale = 0 : thetaRes : 2 * pi;
    
    % Create the H matrix
    H = zeros(length(rhoScale), length(thetaScale));
    
    I = Im > threshold;
    
    % Check each point on the edge image
    for i = 1 : shape(1)
        for j = 1 : shape(2)
            % Skip points below threshold
            if ~I(i, j)
                continue
            end
            
            % Compute the rho values
            rho = j * cos(thetaScale) + i * sin(thetaScale);
            
            % Compute the votes of the line 
            for k = 1 : length(rho)
                l = int32(rho(k) / rhoRes) + 1;
                if l > 0 && l <= length(rhoScale)
                    H(l, k) = H(l, k) + 1;
                end
            end
        end
    end
end
        
        