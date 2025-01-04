function [H,obj]=update_H_TFMKC(Hp,alpha,beta,set_dm,numclass)
[M,V]=size(beta);
beta=beta-beta.^2/2;
% M=length(set_dm);
alphabeta=sqrt(diag(alpha)*beta'*tril(ones(length(set_dm))));
U=[];
for v=1:V
    for m=1:M
        if m==1
            U=[U,alphabeta(v,m)*Hp(:,1:set_dm(m),v)];
        else
            U=[U,alphabeta(v,m)*Hp(:,set_dm(m-1)+1:set_dm(m),v)];
        end
    end
end
[H,S,~]=svds(U,numclass);
obj=trace(S.^2);
end