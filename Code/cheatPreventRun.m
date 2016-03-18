%This script first finds the (3, 4) random grids and then generate
%verification shares using cheatPrevent() function.
%
%@Input-dataset: 'data.mat' contains the secret image scImg, and
%'verifyData.m' contains the verification images verImg.
%@Output: interimShares are the secret shares, and verifyShares are the
%verification shares.
%
%Algorithm for (k, n)-random grids is based on:
%Chen T, Tsao, K. "Threshold visual secret sharing by random grids." 
%Journal of Systems and Software; 2011; 84:p. 1197-1208.

clear;
n = 4;
k = 3;

load('data.mat');
[M N] = size(scImg);
randomShares  = randomGrid( k, scImg);

interimShares = binornd(1,0.5,[n, M, N]);

for x=1:M
    for y=1:N
        arr = randperm(n);
        arr_t = arr(1:k);
        arr_r = arr(k+1:n);
        interimShares(arr_t(randperm(numel(arr_t))),x,y)=randomShares(:,x,y);
        interimShares(arr_r,x,y)=randomShares(randi(k),x,y);
    end
end

verifyShares = cheatPrevent(interimShares,n);

a = squeeze(interimShares(1,:,:));
b = squeeze(interimShares(2,:,:));
c = squeeze(interimShares(3,:,:));
d = squeeze(interimShares(4,:,:));


%These were used to check if things were working
% e = squeeze(interimShares(5,:,:));
% figure;
% imview(and(a,b))
% figure
% imview(and(and(a,b),c))
% figure;
% imview(and(and(and(a,b),c),d))
% imshow(and(and(and(and(a,b),c),d),e))