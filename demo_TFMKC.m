%------------------- This is a demo of the proposed TFMKC -------------------
clear;clc

datasetpath = '.\datasets\';
path_eval = '.\evaluation\';
path_mea = '.\measure\';
savepath = '.\results\';

addpath(genpath(path_eval));
addpath(genpath(path_mea));

dataNameset = {'politicsuk_3view'};
myres=[];
for id = [1]
    %--------------------------------- Load -----------------------------------
    dataName = dataNameset{id};
    disp(dataName);
    
    load([datasetpath,dataName,'_Kmatrix'],'KH','Y');
    %------------------------------------------------------
    Y(Y==-1)=2;
    numclass = length(unique(Y)); %cluster
    numker = size(KH,3);          %view
    num = size(KH,1);             %sample number
    dataset_imf = [num numclass numker];
    % -------------------------------------------------------------------------
    for p = 1:numker
        KH(:,:,p)=(KH(:,:,p)+KH(:,:,p)')/2;
    end
    %------------------------- The Proposed TFMKC ---------------------------
    tic;
    [H,alpha,beta] = TFMKC(KH,numclass);
    [res_mean,res_std]= myNMIACCV2(H,Y,numclass);
    timecost = toc;
    %---------------------------- Print and Save ------------------------------
    fprintf('ACC: %f, NMI: %f, Purity: %f, ARI: %f\n', res_mean(1), res_mean(2), res_mean(3), res_mean(4));
    save([savepath,dataName,'_performance.mat'],'res_mean','res_std','H','timecost','alpha','beta')
end

