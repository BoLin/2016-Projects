%% ECE593 HW7 HMM
clear all
clc
close all
% load the data
load 112_A_hmm.mat
% addpath to the hmm toolbox
addpath(genpath('../HW7_Bo_Lin/HMMall'))
addpath(genpath('../HW7_Bo_Lin/bnt-master'))

%initial parameter setting
k = 4;%number of k fold
state_num = 2:30;%number of hidden state
iter_num = 1;%number of iterations
meanloglik1 = zeros(iter_num,length(state_num));%initialize ll
meanloglik2 = zeros(iter_num,length(state_num));
O1 = size(unique(data1),1); %number of observation
O2 = size(unique(data2),1);


for iter = 1:iter_num
    
   [tdata1,vdata1] = folddata(data1,k);% fold data
   [tdata2,vdata2] = folddata(data2,k);
    
    for i = 1:length(state_num)
        Q1 = state_num(i); %number of states
        Q2 = state_num(i); %number of states
        [ml1,~,~,~,~,~] = HMM(tdata1,vdata1,Q1,O1);
        meanloglik1(iter,i) = ml1;
        [ml2,~,~,~,~,~] = HMM(tdata2,vdata2,Q2,O2);
        meanloglik2(iter,i) = ml2;
    end
end

%% classification
%find the best hidden state number
meanlog1 = mean(meanloglik1,1);
best1 = state_num(find(meanlog1== max(meanlog1)));
meanlog2 = mean(meanloglik2,1);
best2 = state_num(find(meanlog2== max(meanlog2)));

X = [X1;X2;X3;X4;X5;X6];
[a1,b1,prior1,transmat1,obsmat1,ml1] = HMM({data1},{X},best1,3);
[a2,b2,prior2,transmat2,obsmat2,ml2] = HMM({data2},{X},best2,3);

for i = 1:size(ml1)
    if ml1(i)>ml2(i)
        class(i) = 1;
    else
        class(i) = 2;
    end
end

plot_result%plot result

pause
%% Bonus point
close all
clc
fprintf('--------------Bonus-------------------\n');
mixtureBNT


