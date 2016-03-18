function [ ep ] = penalizedEnergy( Tq, Tf, C, n )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nDas = size(C,2);
elemTq = sum(Tq);
tq = find(Tq) - 1;
tf = find(Tf) -1;

maxTq = 2^n -1;

assert(all(size(C) == [n,nDas]))
assert(all(size(Tq) == [1,maxTq+1]))
assert(all(size(Tf) == [1,maxTq+1]))



qShare = de2bi(tq,n,'left-msb');
fShare = de2bi(tf,n,'left-msb');

Nq = 0;
for i=1:size(qShare,1)
    temp1 = qShare(i,:)';
    temp2 = repmat(temp1, 1, nDas);
    temp2 = temp2 .* C;
    temp3 = sum(temp2,1);
    if all(temp3)
        Nq = Nq+1;
    end
end

Nf = 0;
for i=1:size(fShare,1)
    temp1 = fShare(i,:)';
    temp2 = repmat(temp1, 1, nDas);
    temp2 = temp2 .* C;
    temp3 = sum(temp2,1);
    if all(temp3)
        Nf = Nf+1;
    end
end

ep = Nf + (elemTq/(1+Nq));

end