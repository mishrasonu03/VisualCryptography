%This script generates extended visual cryptographic random shares for
%general access structures (GAS) for binary secret images. The access 
%structure is represented by the (Tq, Tf) where Tq is the qualified set 
%and Tf is the forbidden set.
%
%The GAS framework has been borrowed from:
%Kai-Hui Lee, Pei-Ling Chiu, “An Extended Visual Cryptography Algorithm for
%General Access Structures”, IEEE Trans on Information Forensics and Security, 
%vol. 7, no. 1, Feb2012.
%
%The stamping algorithm and the use of random grids is novel. The algorithm
%later got published in:
%SK Mishra, K Biswaranjan, "Extended visual cryptography for general access
%structures using random grids", Advances in Computing, Communication and
%Informatics (ICACCI), 2015 IEEE International Conference, pp. 1924-1929
%

%% parameters
% clear;
n = 4;

Tq = [0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1];
% Tq = [0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 1];
Tf = ones(1,2^n) - Tq;
beta = 0.5;
lam = 0.5;

load('data.mat');
%coImg=1-coImg;
%% one secret image scImg and n cover images coImg1, coImg2,coImg3,coImg4
%% coImg should be n*M*N size

[ nDas, C] = GAS_SOLVER( n+2, n, Tq, Tf);
modCa = sum(C,2);
[M N] = size(scImg);


randomShares  = randomGrid( nDas, scImg);

interimShares = ones(n, M, N);

for i=1:n
    for j=1:nDas
        if C(i,j)
            interimShares(i,:,:) = and(interimShares(i,:,:), randomShares(j,:,:));
        end
    end
end


for x=1:M
    for y=1:N
        d = rand() < beta;
        if ~d
            for k=1:n
                if coImg(k,x,y) 
                     if modCa(k)>=2
                        interimShares(k,x,y) = rand() < 0.5;
                     end
                else
                    interimShares(k,x,y) = 0;
                end
            end
        end
    end
end


a1 = squeeze(interimShares(1,:,:));
b1 = squeeze(interimShares(2,:,:));
c1 = squeeze(interimShares(3,:,:));
d1 = squeeze(interimShares(4,:,:));

% imshow(and(a1,b1))
figure;
imshow(and(and(a1,b1),c1))
imshow(double(and(and(and(a1,b1),c1),d1)))