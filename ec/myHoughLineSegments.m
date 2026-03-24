function [lines] = myHoughLineSegments(lineRho, lineTheta, Im)
    nLines = length(lineRho);
    
    shape = size(Im);

    s = struct;
    s.start = [0, 0];
    s.stop = [0, 0];
    
    lines = repmat(s, nLines, 1);
    
    for i = 1 : nLines
        
        % Create an array of line segment candidates 
        % [length starty startx stopy stopx]
        segments = [];
        line = [];
        
        % Scan all possible points
        for x = 1 : shape(2)
            y = round(x / 
        end
        
    end
end