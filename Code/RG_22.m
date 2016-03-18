function [ randomShares ] = RG_22( n, scImg )
%RG_22 implements of (n, n) random grids using (2, 2) random grids 
%recursively. 
%
%@Input: scImg (secret image), n (number of secret shares required)
%@Output: randomShares (secret shares)
%
%Based on the paper:
%Chen TH, Tsao KH. "Visual secret sharing by random grids revisited." 
%Pattern Recognition; 2009; 42:p. 2203-2217.

[M N] = size(scImg);
randomShares = zeros(n, M, N);

for i=1:n-1
    A = randomGrid(2, scImg);
    randomShares(i,:,:) = A(1,:,:);
    scImg = squeeze(A(2,:,:));
end
randomShares(n,:,:) = A(2,:,:);

end

