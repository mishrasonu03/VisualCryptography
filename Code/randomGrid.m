function [ randomShares ] = randomGrid( n, scImg)
%randomGrid implements (n, n) random grids.
%
%@Input: scImg (secret image), n (number of secret shares)
%@Output: randomShares (secret shares)
%
%Based on the paper:
%Shyong Jian Shyu, "Image encryption by multiple random grids", 
%Pattern Recognition vol. 42, pp. 1582 - 1596, 2009.

[M N] = size(scImg);
randomShares = zeros(n, M, N);

randomShares(1:n-1,:,:) = randi([0 1],[n-1, M, N]);
A = randomShares(1,:,:);

for i=2:n-1
    A = xor(A, randomShares(i,:,:));
end

A = squeeze(A);
randomShares(n,:,:) = xor(scImg, A);

end

