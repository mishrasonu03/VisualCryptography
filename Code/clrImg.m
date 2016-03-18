%This script generates extended visual cryptographic random shares for
%general access structures (GAS) for color secret images. The access 
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
clear;
n = 4;

Tq = [0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1];
Tf = ones(1,16) - Tq;
beta = 0.7;
% lam = 0.5;

load('clrImg.mat');
% coImg=1-coImg;
%% one secret image scImg and n cover images coImg1, coImg2,coImg3,coImg4
%% coImg should be n*M*N size
clr_coImg=coImg;
clr_scImg=scImg;
clear coImg scImg;
M=300; N=600; %size of images;
interimShares = ones(4, M, N, 3);

for comp=1:3
    coImg = clr_coImg(:,:,:,comp);
    scImg = clr_scImg(:,:,comp);    
    scImg = jarvisHalftone(scImg);
    
    coImg1 = coImg; clear coImg;
    for i=1:n
        coImg(i,:,:) = jarvisHalftone(squeeze(coImg1(i,:,:)));
    end
    
    % scImg = scImg > 127;
    % coImg = coImg/255;
    
    [ nDas, C] = GAS_SOLVER( n+2, n, Tq, Tf);
    [M N] = size(scImg);
    
    randomShares  = RG_22( nDas, scImg);
%     interimShares(:,:,:,comp) = randomShares;    
    for i=1:n
        for j=1:nDas
            if C(i,j)
                interimShares(i,:,:,comp) = and(interimShares(i,:,:,comp), randomShares(j,:,:));
            end
        end
    end

    % Sonu's method
%     for x=1:M
%         for y=1:N
%             d = rand() < beta;
%             if ~d
%                 for k=1:n
%                     p = double(coImg(k,x,y))/255;
%                     interimShares(k,x,y,comp) = binornd(1,p/2);
%                 end
%             end
%         end
%     end
    
%     % paper's method
    for x=1:M
        for y=1:N
            d = rand() < beta;
            if ~d
                for k=1:n
                    if coImg(k,x,y)
                        interimShares(k,x,y,comp) = rand() < 0.5;
                    else
                        interimShares(k,x,y,comp) = 0;
                    end
                end
            end
        end
    end
    
%     a = squeeze(interimShares(1,:,:,comp));
%     b = squeeze(interimShares(2,:,:,comp));
%     c = squeeze(interimShares(3,:,:,comp));
%     d = squeeze(interimShares(4,:,:,comp));
    
%     figure;
%     imshow(and(and(and(a,b),c),d))
    
end