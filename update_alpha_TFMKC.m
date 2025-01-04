function alpha=update_alpha_TFMKC(beta,L)
beta=beta-beta.^2/2;
betaL=sum(beta.*L,1)';
alpha=betaL/norm(betaL,2);
end