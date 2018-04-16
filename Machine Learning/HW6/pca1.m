function [xd, xx, xxmse] = pca1(x,d)
% function [xd, xx, xxmse] = pca(x,d)
% 
% perform principle components analysis on the dataset x of order d.
%
% x = input dataset
% d = number of principal components
% xd = the set of components of the data instances in the direction of the
% d principal eigenvectors
% xx = the reconstucted dataset, obtained by projection onto its d
% principal components
%
% xxmse = the mean-squared reconstruction error for the data-set (per
% sample, per attribute)
%
% Yon Visell, Dec. 1 2005;  Modified March 2006.

m = size(x,1);              % number of instances  SIZE(X,1) returns the number of rows.
f = size(x,2);              % number of attributes per instance

b = mean(x,1);              % mean of inputs  MEAN(X,DIM) takes the mean along the dimension DIM of X.
bb = ones(m,1) * b;         %average for every row

s = (x - bb)' * (x - bb);   % PCA scattering matrix
[v,l] = eig(s);             % Eigenvalue decomposition l=D s*V=V*l
[ll,ii] = sort(diag(l));    % Sorted eigenvalue set ll with permutation ii

vv = v(:,ii);               % sorted fxf matrix of eigenvectors
vvd = vv(:,(f-d+1):f);      % d principal eigenvectors  =W=C
    
xd = (x - bb) * vvd;        % components of x in the direction of the d principal eigenvectors

xx = bb + ((x - bb) * vvd) * vvd';       % the reconstructed dataset
xx = max(xx,0);                          % assume we are working with positive data (images)

xxmse = sum(sum((xx - x).^2)) / (m*f);   % mean squared error per sample, per attribute
xxmsem = sum((xx - x).^2,2) / f;         % mean squared error per attribute

% uncomment this to compare a random image with its reconstruction:
%  ind = randint(1,1,m)+1;   
%  idataxx = reshape(xx(ind,1:64),8,8)';
%  idatax = reshape(x(ind,1:64),8,8)';
%  colormap(gray); imagesc(1-cat(2,idatax,idataxx))
%  title(strcat('Left: Original, Right: PCA, Index=',num2str(ind),' PCA-Dimension=',num2str(d)));