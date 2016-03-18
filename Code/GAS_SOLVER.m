function [ nDas, C] = GAS_SOLVER(nMaxdas, n, Tq, Tf)
%GAS_SOLVER generates n', the number of shares required to accommodate
%general access structure given in terms of qualified and forbidden sets.
%
%@Input: nMaxDas (maximum value of n'), n (number of secret shares), Tq
%(qualified set) and Tf (forbidden set)
%@Output: nDas (n') and C (mapping between n' shares to n shares)
%
%Based on:
%Kai-Hui Lee, Pei-Ling Chiu, “An Extended Visual Cryptography Algorithm for
%General Access Structures”, IEEE Trans on Information Forensics and Security, 
%vol. 7, no. 1, Feb2012.
%
%Written By: Kumar Biswaranjan (then at IIT Guwahati, now at HP)

nDas = n;
C = 0;

while 1
    [cBest, zBest] = GAS_SA(n, nDas, Tq, Tf);

    if zBest >= 1
        if nDas == nMaxdas
            disp('No solutin found')
            return;
        end
        if nDas >= n
            nDas = nDas + 1;
            continue;
        end

        if nDas < n
            nDas = nDas +1;
            return;
        end

    else
        C = cBest;
        if nDas > n
            return;
        end
        if nDas <= n
            nDas = nDas - 1;
            continue;
        end
    end
end



end

