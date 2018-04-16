%% ECE593 HW6 SVM
clear all
clc
close all
% load the optdigits
load 264_optdigits.mat
% addpath to the libsvm toolbox
addpath(genpath('../HW6_Bo_Lin/libsvm-3.21'))

%% Feature Scaling
scale = 0;%[0 1] scaling
%scale = 1;% [-1 1 scaling]


%% select training and testing data
v = 5; % select the number of fold for cross-validation
label = randi(v,size(data,1),1);% divide the data randomly into the folds
accuracy_matrix = zeros(5,2,v);
svnumber = zeros(5,2,v);
dmatrix = zeros(5,2,v,5);
paramatrix = zeros(5,2,v,2);

tic
%% dimention choices
for d = [4] 
    dimension = log2(d)-1;
    [xd1, xx1, xxmse1] = pca1(data,d);%data is the unsupervised data
    
    for i =1:size(xd1,2)
        range = max(xd1(:,i)) - min(xd1(:,i));
        if range == 0
            data_scaled(:,i) = zeros(size(data,1),1);
        else
            data_scaled(:,i) = 1/range.*(xd1(:,i)-min(xd1(:,i)));
        end
    end
    
    if scale == 1
        data_scaled = data_scaled.*2-ones(size(data_scaled));
    end
    
    
    for fold =1:v
        %define training and testing set and label
        test_data = data_scaled(label == fold,:);
        test_label = c(label == fold);
        
        train_data = data_scaled(label ~= fold,:);
        train_label = c(label ~= fold);
        
        %initial
        accuracy_old = 0;%initial accuracy
        best_para_C = -5;
        best_para_gama = -15;
        
        %% linear
        type =0; % 0 for linear, 2 for rbf
        %% Train the SVM
        
        % Loose grid search
        for i = -5:2:15
            C = 2^i;
            option = sprintf('-s 0 -t %d -c %d -b 1 ',type,C);
            model = svmtrain(train_label,train_data,option);
            
            %% Use the SVM model to classify the data
            [pridict_label, accuracy, prob_value] = svmpredict(test_label,test_data,model,'-b 1');
            
            
            %% Save Best Loose Grid-search
            
            if accuracy(1) > accuracy_old
                best_para_C = i;
                accuracy_old = accuracy(1);
                number_linear_sv = model.totalSV;
                
            end
            
            
        end
        
        paramatrix(dimension,type+1,fold,1)=  2^best_para_C;
        
        
        %% Fine Grid Search
        for fi = best_para_C-2:0.25:best_para_C+2
            C=2^fi;
            
            option = sprintf('-s 0 -t %d -c %d -b 1 ',type,C);
            model = svmtrain(train_label,train_data,option);
            
            %% Use the SVM model to classify the data
            [pridict_label, accuracy, prob_value] = svmpredict(test_label,test_data,model,'-b 1');
            
           
            %% Save Best Loose Grid-search
            if accuracy(1) > accuracy_old
                best_para_linear_C = i;
                accuracy_old = accuracy(1);
                number_linear_sv = model.totalSV;
                dmatrix(dimension,type+1,fold,:)= model.Parameters;
                paramatrix(dimension,type+1,fold,1)= 2^best_para_linear_C;
            end
            
        end
        
        accuracy_matrix(dimension,type+1,fold) = accuracy_old;
        svnumber(dimension,type+1,fold)=number_linear_sv;
        
        
        %% RBF
        accuracy_old  =0;
        type = 2;% RBF
        % Loose grid search
        i0=1;
        for i = -5:2:15
            C = 2^i;
            j0=1;
            for j = -15:2:3
                gamma = 2^j;
                option = sprintf('-s 0 -t %d -c %d -b 1 -g %d',type,C,gamma);
                model = svmtrain(train_label,train_data,option);
                
                %% Use the SVM model to classify the data
                [pridict_label, accuracy, prob_value] = svmpredict(test_label,test_data,model,'-b 1');
                
                 cvMatrix_loose(i0,j0)=accuracy(1);
                 
                 svMatrix_loose(i0,j0)=model.totalSV;
                %% Save Best Loose Grid-search
                
                if accuracy(1) > accuracy_old
                    best_para_C = i;
                    best_para_gama = j;
                    number_rbf_sv = model.totalSV;
                    paramatrix(dimension,type+1,fold,:)= [2^i;2^j];
                    accuracy_old = accuracy(1);
                end
                j0=j0+1;
                
            end
            i0=i0+1;
            
        end
        
        best_para_rbf_C = best_para_C;
        best_para_rbf_gama = best_para_gama;
        
        %% Fine Grid Search
        ii=1;
        for fi = best_para_C-2:0.25:best_para_C+2
            C=2^fi;
            jj=1;
            for fj = best_para_gama-2:0.25:best_para_gama+2
                gama = 2^fj;
                option = sprintf('-s 0 -t %d -c %d -b 1 -g %d',type,C,gamma);
                model = svmtrain(train_label,train_data,option);
                
                %% Use the SVM model to classify the data
                [pridict_label, accuracy, prob_value] = svmpredict(test_label,test_data,model,'-b 1');
                
                   cvMatrix_fine(ii,jj)=accuracy(1);%accuracy for c and gama
                   
                  
                %% Save Best Loose Grid-search
                
                if accuracy(1) >= accuracy_old
                    best_para_rbf_C = i;
                    best_para_rbf_gama = j;
                    number_rbf_sv = model.totalSV;
                    accuracy_old = accuracy(1);
                    dmatrix(dimension,type,fold,:)= model.Parameters;
                    
                    paramatrix(dimension,type+1,fold,:)= [2^i;2^j];
                end
                jj=jj+1;
            end
            ii=ii+1;
        end
        
        accuracy_matrix(dimension,type,fold) = accuracy_old;
        svnumber(dimension,type,fold)=number_rbf_sv;
        
        
    end
end
toc
%% result plotting

for d = 1:5
    for type=1:2
        accuracy_mean(d,type) = nanmean(accuracy_matrix(d,type,:));
    end
end

figure
plot(accuracy_mean,'-o')
grid on
dimensionlabel= {'4','8','16','32','64'};
set(gca,'XTick',(1:1:5),'XTickLabel',dimensionlabel)
legend('Linear SVM','RBF SVM','Location','southeast')
ylabel('Average Cross-Validation Accuracy %')
xlabel('Dimension')
title('Dimension vs Validation Accuracy')

 

for d = 1:5
    for type=1:2
        sv_mean(d,type) = nanmean(svnumber(d,type,:));
    end
end
figure
plot(sv_mean,'-o')
grid on
dimensionlabel= {'4','8','16','32','64'};
set(gca,'XTick',(1:1:5),'XTickLabel',dimensionlabel)
legend('Linear SVM','RBF SVM','Location','southeast')
ylabel('Average Number of Support Vector')
xlabel('Dimension')
title('Dimension vs Number of Support Vector')



figure
imagesc(cvMatrix_loose); colormap('jet'); colorbar;
set(gca,'XTickLabel',sprintf('%d\n',-15:2:3))
xlabel('Log_2\gamma');
set(gca,'YTickLabel',sprintf('%d\n',-5:2:15))
ylabel('Log_2c');
title('Loose Grid Search')

figure
imagesc(cvMatrix_fine); colormap('jet'); colorbar;
set(gca,'XTickLabel',sprintf('%3.1f\n',best_para_C-2:0.25:best_para_C+2))
xlabel('Log_2\gamma');
set(gca,'YTickLabel',sprintf('%3.1f\n',best_para_gama-2:0.25:best_para_gama+2))
ylabel('Log_2c');
title('Fine Grid Search')


figure
imagesc(svMatrix_loose); colormap('jet'); colorbar;
set(gca,'XTickLabel',sprintf('%d\n',-15:2:3))
xlabel('Log_2\gamma');
set(gca,'YTickLabel',sprintf('%d\n',-5:2:15))
ylabel('Log_2c');
title('# of SV in Parameter Grid')



