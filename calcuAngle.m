% a = [0,0,0];
% b = [1,0,0];
% c = [1,-1,0];
% 
% v1 = b - a;
% v2 = c - a;
% 
% angle1 = atan2(norm(cross(v1,v2)), dot(v1,v2)) *180/pi

% a = [0,0];
% b = [-100,0];
% c = [1,2];

function angle = calcuAngle(p1,p2,p3,p4)

    v1 = p1 - p2;
    v2 = p3 - p4;

    angle = mod(atan2( det([v1;v2]) , dot(v1,v2) ) *180/pi, 180);
    
end
