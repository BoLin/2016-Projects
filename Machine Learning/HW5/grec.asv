%% ECE593 HW5 grec.m
function likelihood = grec(X,GMM)
    mu = GMM.mu;
    phi = GMM.phi;
    sigma = GMM.sigma;
    k = GMM.k;
    m = size(X,1);
    
    likelihood = zeros(m,1);
    for i = 1:m
        for j = 1:k
            likelihood(i) = likelihood(i) + phi(j)*gaussianND(X(i,:), mu(:,j)', sigma(:,:,j));
        end
    end
end