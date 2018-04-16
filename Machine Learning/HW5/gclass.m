%% ECE593 HW5 gclass.m
function [ls,softls] = gclass(X,GMM0,GMM1)
    likelihood0 = grec(X,GMM0);
    likelihood1 = grec(X,GMM1);
    
    softls = likelihood1-likelihood0;
    ls = softls>0;
end
