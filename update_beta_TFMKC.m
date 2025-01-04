function [beta,L]=update_beta_TFMKC(Hp,H,set_dm)
M=length(set_dm);
V=size(Hp,3);
% [M,V]=size(beta);
L=zeros(M,V);
% alphabeta=sqrt(diag(alpha)*beta'*tril(ones(length(set_dm))));
% U=[];
for v=1:V
    for m=1:M
        if m==1
            L(m,v)=norm(H'*Hp(:,1:set_dm(m),v),'fro')^2;
        else
            L(m,v)=norm(H'*Hp(:,set_dm(m-1)+1:set_dm(m),v),'fro')^2;
        end
    end
end
L=tril(ones(M))*L;
beta=L*0;
for v=1:V
beta(:,v) = EProjSimplex_new_ZJP_V2(L(:,v),-L(:,v));
end
% beta=L./repmat(sqrt(sum(L.^2,1)),M,1);
end