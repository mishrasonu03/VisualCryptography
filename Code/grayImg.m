%This script generates extended visual cryptographic random shares for
%general access structures (GAS) forgrayscale secret images. The access 
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
%clear;
n = 4;

Tq = [0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1]; %qualified set
Tf = ones(1,16) - Tq; %forbidden set
beta = 0.3;
% lam = 0.5;

load('grayImg4.mat');
% coImg=1-coImg;
%% one secret image scImg and n cover images coImg1, coImg2,coImg3,coImg4
%% coImg should be n*M*N size

scImg = jarvisHalftone(scImg);

% coImg1 = coImg; clear coImg;
% for i=1:n
% coImg(i,:,:) = jarvisHalftone(squeeze(coImg1(i,:,:)));
% end

% scImg = scImg > 127;
% coImg = coImg/255;

[ nDas, C] = GAS_SOLVER( n+2, n, Tq, Tf);
[M N] = size(scImg);


randomShares  = RG_22( nDas, scImg);

interimShares = ones(n, M, N);

for i=1:n
    for j=1:nDas
        if C(i,j)
            interimShares(i,:,:) = and(interimShares(i,:,:), randomShares(j,:,:));
        end
    end
end

%Below are the different ways of stampoing that we tried

% ab = sum(C,2);
% k = find(ab>1);
% l = size(k);
% 
% for x=1:M
%     for y=1:N
%         for z=1:l
%             if scImg(x,y)
%                 interimShares(k(z),x,y) = rand()<0.5;
%             end
%         end
%     end
% end

% Sonu's method
for x=1:M
    for y=1:N
        d = rand() < beta;
        if ~d
            for k=1:n
                p = double(coImg(k,x,y))/255;                
                interimShares(k,x,y) = binornd(1,p/2);                
            end
        end
    end
end

% for x=1:M
%     for y=1:N
%         d = rand() < beta;
%         if ~d
%             for k=1:n
%                 if coImg(k,x,y) 
%                     interimShares(k,x,y) = rand() < 0.5;
%                 else
%                     interimShares(k,x,y) = 0;
%                 end
%             end
%         end
%     end
% end

% Biswaranjan's method
% for x=1:M
%     for y=1:N
%         d = rand() < beta;
%         if ~d
%             for k=1:n
%                 r = 255*rand();
%                 if r < coImg(k,x,y) 
%                     interimShares(k,x,y) = 1;
%                 else
%                     interimShares(k,x,y) = 0;
%                 end
%             end
%         end
%     end
% end

a = squeeze(interimShares(1,:,:));
b = squeeze(interimShares(2,:,:));
c = squeeze(interimShares(3,:,:));
d = squeeze(interimShares(4,:,:));

figure;
imshow(and(and(and(a,b),c),d))
