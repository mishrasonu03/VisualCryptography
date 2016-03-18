function verifyShares = cheatPrevent(interimShares,n)
%cheatPrevent produces the verification shares cheat-prevention in random
%grids based visual cryptography
%
%@Input: interimShares (secret shares), n(number of verification required)
%@File: 'verifyData.mat' contains the verification images
%@Output: verifyShares (verification shares)
%
%Based on our paper:
%S. K. Mishra and K. Biswaranjan, "Robust Cheat-Prevention for Random Grids
%based Visual Secret Sharing Scheme"
%Procedia Computer Science 46 (2015) 517 – 523

R = interimShares;
load('verifyData.mat');
M=300; 
N=600;

for t=1:n
    for i=1:M
        for j=1:N
            u = randi(n);
            if verImg(t,i,j)
                verifyShares(t,i,j) = R(u,i,j); %rand>0.5;
            else
                verifyShares(t,i,j) = not(R(u,i,j));
            end
        end
    end
end

end