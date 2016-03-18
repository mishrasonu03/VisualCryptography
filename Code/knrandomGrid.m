function [ randomShares ] = knrandomGrid( k, n, scImg)
%knRandomGrid generates (k,n)-random grid secret shares for color/grascale/
%binary images. each color component of color images is broken into binary
%images using the halftoning technique by Jarvis
%
%@Input: scImg (secret image), k,n usual meaning in (k,n)-random grids
%@Output: randomShares secret shares

% if to be used as a script
% n = 5;
% k = 2;
% load('F:\Projects\IITG\Network Security\code\code\data.mat')

clr_scImg=scImg;
%[M N] = size(scImg);
M=300; N=600;
randomShares = zeros(n, M, N,1);

for comp=1 %change to comp=1:3 for color images
    scImg = clr_scImg(:,:,comp);
%     scImg = jarvisHalftone(scImg); % halftoning to convert into binary
    
    if numel(k)==1
        randomShares(1:k,:,:,comp) = randomGrid( k, scImg);
        no = k;
        
        while (no <n)
            start = no-k+2;
            A = randomShares(start,:,:,comp);
            
            for i=start+1:no
                A = xor(A, randomShares(i,:,:,comp));
            end
            
            A = squeeze(A);
            randomShares(no+1,:,:,comp) = xor(scImg, A);
            no = no+1;
        end
    else
        i=1;
        randomShares(1:k(i),:,:,comp) = randomGrid( k(i), scImg);
        no = k(i);
        i=i+1;
        while (i <= numel(k))
            if ~k(i), i=i+1; continue; end;
            strt = i;
            fin = i + k(i)-1;
            randomShares(no+1:fin-1,:,:,comp) = binornd(1,0.5,[fin-no-1, M, N]);
            A = randomShares(strt,:,:,comp);
            for j=strt+1:fin-1
                A = xor(A,randomShares(j,:,:,comp));
            end
            A = squeeze(A);
            randomShares(fin,:,:,comp) = xor(scImg, A);
            no = fin;
            i=i+1;
        end
    end
end