%% ECE593 HW5 main.m
%% initialization
clear all;
close all;
clc;
xa=2; xb=4; ya=1; yb=3;         %% Family Car
%%
num = 5;
generr = zeros(4,5,num);%generalization error
[X,Y] = meshgrid(0:.05:5,0:.05:5);

for kk = 1:num
    ii=1;
    
    
    for N = [50 100 200 500]
        jj=1;
        
        
        for k = [1 2 4 8 16]
            N
            k
            
            incar = 0;%initially no data
            while(incar < k)
                [ds,ls] = randomcar(N);
                ds_1 = ds(ls==1,:);
                ds_0 = ds(ls==0,:);
                incar = size(ds_1,1);
            end
            [vds,vls] = randomcar(N/2); %validation dataset 50%
            
            
            %train model
            try
                GMM1 = gtrain(ds_1,k);
                GMM0 = gtrain(ds_0,k);
                [vls_GMM,vgap] = gclass(vds,GMM0,GMM1);
                
            catch
                warning(['N = ',num2str(N),'k = ',num2str(k)]);
                generr(ii,jj,kk) = NaN;
                continue % no plotting
            end
            
            generr(ii,jj,kk) = sum(abs(vls-vls_GMM))/N;
            
           if kk ==1
            %% result plotting
            figure
            hold on;
            box on;
            title(['N=',num2str(N),' k=',num2str(k)]);
            for i=1:size(ds,1)
                x=ds(i,1);
                y=ds(i,2);
                if (ls (i)==1)
                    plot(x,y,'+b','LineWidth',2);
                else
                    plot(x,y,'or','LineWidth',2);
                end
            end
            plot([xa xb xb xa xa],[ya ya yb yb ya],'-');
            %plot boundary line
            for i=1:length(X)
                for j=1:length(Y)
                    t = [X(i,j),Y(i,j)];
                    [l,Z(i,j)] = gclass(t,GMM0,GMM1);
                    Z0(i,j) = grec(t,GMM0);
                    Z1(i,j) = grec(t,GMM1);
                   
                end
            end
            contour(X,Y,Z,[0 0],'r','LineWidth',2)
            contour(X,Y,Z0)
            contour(X,Y,Z1)
            for i=1:size(vds,1)
                x=vds(i,1);
                y=vds(i,2);
                if (vls (i)==1)
                    plot(x,y,'gx','LineWidth',2);
                else
                    plot(x,y,'md','LineWidth',2);
                end
            end
           end
            jj=jj+1;
        end
        ii=ii+1;
    end
    
end


color = {'-b*','-ko','-r^','-ms','-g+'};
AvgGenErr = nanmean(generr,3);

f1 = figure(100);
movegui(f1,'southeast')
hold on;
for i=1:4
    plot([1 2 4 8 16],AvgGenErr(i,:),color{i},'LineWidth',2,'MarkerSize',10);
end
legend('N=50','N=100','N=200','N=500');
title('Validation Generalization Error Rate'); 
xlabel('Number of Clusters');
ylabel('Error Rate');
grid on;
box on;

f2 = figure(101);
movegui(f2,'southwest')
hold on;
for i=1:5
    plot([50 100 200 500],AvgGenErr(:,i),color{i},'LineWidth',2,'MarkerSize',10);
end
legend('k=1','k=2','k=4','k=8','k=16');
title('Validation Generalization Error Rate'); 
xlabel('Number of Data Points');
ylabel('Error Rate');
grid on;
box on;

