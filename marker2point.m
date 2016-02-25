function points = marker2point(markers)

  % 2D points
  if size(markers,2) == 9 

    points = [];
    for dd = 1: size(markers,1)
        points = [points;
            markers(dd,[2:3]);
            markers(dd,[4:5]);
            markers(dd,[6:7]);
            markers(dd,[8:9])];
    end
    
  % 3D points
  elseif size(markers,2) == 13
    
    points = [];
    for dd = 1: size(markers,1)
        points = [points;
            markers(dd,[2:4]);
            markers(dd,[5:7]);
            markers(dd,[8:10]);
            markers(dd,[11:13])];
    end
    
  end
      
end