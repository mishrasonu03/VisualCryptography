function [ cBest, zBest ] = GAS_SA( n, nDas, Tq, Tf)
%Written By: Kumar Biswaranjan (then at IIT Guwahati, now at HP)


%% params
t0 = 1;
r0 = 100;
alphaT = 0.75;
betaT = 1.5;
tf = t0/10;

%% algo
C = ones(n, nDas);
ep = penalizedEnergy(Tq, Tf, C,n);
zOld = ep;
zBest = zOld;
cBest = C;
t = t0;
r = r0;

maxTq = 2^n -1;
assert(all(size(C) == [n,nDas]))
assert(all(size(Tq) == [1,maxTq+1]))
assert(all(size(Tf) == [1,maxTq+1]))

while (zOld >= 1 && t >= tf)
    for i=1:floor(r)
        randN = randi(n);
        cNew = C;
        
        temp = randi([0 1],[1,nDas]);
%         while ~all(sum(cNew, 1))
%             
%             randN1 = randi(2^nDas -1);
%             cNew(randN, :) = de2bi(randN1,nDas);
%             
% %             temp = randi([0 1],[1,nDas]);
% %             cNew(randN, :) = temp;
% 
% %             if ~all(sum(cNew, 1))
% %                 colSum = sum(cNew, 1);
% %                 a = find(colSum == 0);
% %                 cNew(randN, a(1)) =1;
% %             end
%         end
        cNew(randN, :) = temp;
        
        ep = penalizedEnergy(Tq, Tf, cNew,n);
        delE = ep - zOld;
        p = rand();
        if (delE < 0 || p < exp( -delE/t))
            zOld = ep;
            if (zOld < zBest)
                zBest = zOld;
                cBest = cNew;
                if (zOld < 1)
                    return;
                end
            end
            C = cNew;
        end
    end
    t = alphaT * t;
    r = betaT * r;
end

        


end

