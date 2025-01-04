function [H,alpha,beta] = TFMKC(KH,numclass)
%------------------------- The Proposed MKC_alphabeta ---------------------------
[num,~,numker]=size(KH);
% d_max=min(num,numclass*25); % d_max should be big enough
% --------------- 1 ----------------
% set_dm=[1:10]*numclass;
% --------------- 2 ----------------
% set_dm=[1:2:9]*numclass;
% --------------- 3 ----------------
% set_dm=[2:5]*numclass;
% --------------- 4 ----------------
% set_dm=[1:20]*numclass;
% --------------- 5 ----------------
% set_dm=[1:15]*numclass;
% --------------- 6 ----------------
if num/numclass<70
    set_dm=[1:10]*numclass;
elseif num/numclass<120
    set_dm=[1:15]*numclass;
else
    set_dm=[1:20]*numclass;
end
% --------------- - ----------------
M=length(set_dm);
d_max=max(set_dm);

Hp=zeros(num,d_max,numker);
opt.disp=0;
for p=1:numker
    [Hp(:,:,p),~]=eigs(KH(:,:,p),d_max,'la',opt);
end

alpha=ones(numker,1)/sqrt(numker);
% ------------ V1 --------------
beta=ones(M,numker)/M;
% ------------ V2 --------------
% beta=zeros(M,numker);
% beta(5,:)=1;
% ------------ V3 --------------
% beta=zeros(M,numker);
% beta(10,:)=1;

iter_max=30;
epsilon=1e-5;
iter=1;
[H,obj]=update_H_TFMKC(Hp,alpha,beta,set_dm,numclass);
% obj=obj_TFMKC(Hp,H,alpha,beta,set_dm);
while 1
    [beta,L]=update_beta_TFMKC(Hp,H,set_dm);
    alpha=update_alpha_TFMKC(beta,L);%(Hp,H,beta,set_dm);
    
    iter=iter+1;
    [H,obj(iter)]=update_H_TFMKC(Hp,alpha,beta,set_dm,numclass);
%     obj(iter)=obj_TFMKC(Hp,H,alpha,beta,set_dm);
    if iter>=iter_max || (obj(iter)-obj(iter-1))/obj(iter-1)<epsilon
        break
    end
end

end
