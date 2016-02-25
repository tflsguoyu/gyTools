function intrinsicMatrix = getIntrinsicMatrix(fc, cc)
    
    intrinsicMatrix = [-fc(1),0,cc(1); 0,fc(2),cc(2); 0,0,1];
	
end