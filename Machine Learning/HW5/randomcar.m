%% ECE593 HW5 randomcar.m
function [ds,ls] = randomcar(N)
    ds=zeros(N,2); ls=zeros(N,1);       % labels
   xa=2; xb=4; ya=1; yb=3; 
    for i=1:N
        x=rand(1,1)*5; y=rand(1,1)*5;
        ds(i,1)=x; ds(i,2)=y;
        % +ve if falls in the rectangle, -ve otherwise
        if ((x > xa) && (y > ya) && (y < yb) && ( x < xb)) 
            ls(i)=1;
        else
            ls(i)=0; 
        end;
    end;
end