%ECE693 HW3 Bo Lin
%Press "run" 
%For running the HW3 code, just input training set and testing set size%
%result is shown in command window
%there are pauses in between each question,press any key to continue

clc
clear all
close all
%%
%tutorial of BNT
N = 4; 
dag = zeros(N,N);
C = 1; S = 2; R = 3; W = 4;
dag(C,[R S]) = 1;
dag(R,W) = 1;
dag(S,W)=1;
discrete_nodes = 1:N;
node_sizes = 2*ones(1,N);
bnet = mk_bnet(dag, node_sizes);
%parameters
%CPT = reshape([1 0.1 0.1 0.01 0 0.9 0.9 0.99], [2 2 2]);
bnet.CPD{C} = tabular_CPD(bnet, C, [0.5 0.5]);
bnet.CPD{R} = tabular_CPD(bnet, R, [0.8 0.2 0.2 0.8]);
bnet.CPD{S} = tabular_CPD(bnet, S, [0.5 0.9 0.5 0.1]);
bnet.CPD{W} = tabular_CPD(bnet, W, [1 0.1 0.1 0.01 0 0.9 0.9 0.99]);
%inference
engine = jtree_inf_engine(bnet);%junction tree engine
%w-2, grass is wet
evidence = cell(1,N);
evidence{W} = 2;
[engine, loglik] = enter_evidence(engine, evidence);%enter_evidence implements a two-pass message-passing scheme. The first return argument contains the modified engine, which incorporates the evidence. The second return argument contains the log-likelihood of the evidence
marg = marginal_nodes(engine, S);
fprintf('-----------P(S=2|W=2)---------------\n');
p = marg.T(2)

%%
evidence{R} = 2;
[engine, ll] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [S R W]);
fprintf('-----------P(S=2|W=2,R=2)---------------\n');
p=m.T(2)
%%
%observed nodes
evidence = cell(1,N);
evidence{W} = 2;
engine = enter_evidence(engine, evidence);
m = marginal_nodes(engine, W,1);
fprintf('-----------P(W=1|W=2) = 0 and P(W=2|W=2) = 1---------------\n'); 
m.T

%%
%computing joint distribution
evidence = cell(1,N);
[engine, ll] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [S R W]);
fprintf('-----------Computing Joint Distribution---------------\n');
p=m.T
%%
%add some evidence to R
evidence{R} = 2;
[engine, ll] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [S R W],1);
fprintf('-----------Add evidence to R---------------\n');
m.T
fprintf('-----------End of Tutorial 1, Next Complete/incomplete data---------------\n');
pause
%%
clc
%Maximum likelihood parameter estimation from complete data
nsamples=20;%number of samples
samples = cell(N, nsamples);
for i=1:nsamples
  samples(:,i) = sample_bnet(bnet);
end
data = cell2num(samples);
% Make a tabula rasa
bnet2 = mk_bnet(dag, node_sizes);
seed = 0;
rand('state', seed);
bnet2.CPD{C} = tabular_CPD(bnet2, C);
bnet2.CPD{R} = tabular_CPD(bnet2, R);
bnet2.CPD{S} = tabular_CPD(bnet2, S);
bnet2.CPD{W} = tabular_CPD(bnet2, W);
bnet3 = learn_params(bnet2, samples);
CPT3 = cell(1,N);
for i=1:N
  s=struct(bnet3.CPD{i});  % violate object privacy
  CPT3{i}=s.CPT;
end
fprintf('Learned:\n');
dispcpt(CPT3{4})
CPT = reshape([1 0.1 0.1 0.01 0 0.9 0.9 0.99], [2 2 2]);%use old CPT
fprintf('True:\n');
dispcpt(CPT)

%incomplete data
samples2 = samples;
hide = rand(N, nsamples) > 0.5;
[I,J]=find(hide);
for k=1:length(I)
  samples2{I(k), J(k)} = [];
end

engine2 = jtree_inf_engine(bnet2);
max_iter = 10;
[bnet4, LLtrace] = learn_params_em(engine2, samples2, max_iter);
plot(LLtrace, 'x-r','linewidth',2)
xlabel('iteration')
ylabel('log-likelihood')
for i=1:N
  s=struct(bnet4.CPD{i});  % violate object privacy
  CPT4{i}=s.CPT;
end
fprintf('Learned:\n');
dispcpt(CPT4{4})
fprintf('True:\n');
dispcpt(CPT)

fprintf('--------------End of Tutorial-------------------\n');
fprintf('--------------Press Any Key to run Question 1.4 -------------------\n');
pause
%%
clc
clear all
close all
%%
N = 3; 
Pr = 1; Bt = 2; Ut = 3;
dag = zeros(N,N);
dag(Pr,[Bt Ut]) = 1;
discrete_nodes = 1:N;
node_sizes = 2*ones(1,N);
bnet = mk_bnet(dag, node_sizes);

% Make a tabula rasa
bnet2 = mk_bnet(dag, node_sizes);
seed = 0;
rand('state', seed);
bnet2.CPD{Pr} = tabular_CPD(bnet2, Pr);
bnet2.CPD{Bt} = tabular_CPD(bnet2, Bt);
bnet2.CPD{Ut} = tabular_CPD(bnet2, Ut);


%samples
nsamples=5;%number of samples
samples = cell(N, nsamples);
samples={[], 1, 1, 1, [];
         1,2,1,1,2;
         1,1,[],2,[]}


engine = jtree_inf_engine(bnet2);
max_iter = 10;
[bnet3, LLtrace] = learn_params_em(engine, samples, max_iter);
plot(LLtrace, 'x-r','linewidth',2)
xlabel('iteration')
ylabel('log-likelihood')
for i=1:N
  s=struct(bnet3.CPD{i});  % violate object privacy
  CPT2{i}=s.CPT;
end
fprintf('--------------Result of Question 1.4 -------------------\n');
celldisp(CPT2)
dispcpt(CPT2{1})
dispcpt(CPT2{2})
dispcpt(CPT2{3})

fprintf('--------------Press Any Key to run Question 1.4 -------------------\n');
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc
clear all
close all
prompt='Training set data size [50,100,200,400] =';
N=input(prompt); 
T=0.8*N;%training set percentage
Test=N-T; %test size
xa=2; xb=4; ya=1; yb=3;         % coordinates of the rectangle C
hold on;
plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it
ds=zeros(N,2); ls=zeros(N,1);       % labels
s=1;%initial sample
sn=1;%negtive sample
ss=1;
sample1=zeros(1,2);
testsample=zeros(1,2);
d=2;%bivariate d=2
for i=1:N
x=rand(1,1)*5; y=rand(1,1)*5;
ds(i,1)=x; ds(i,2)=y;
    if i<=T %training set

    if ((x > xa) && (y > ya) && (y < yb) && ( x < xb))
        ls(i)=1;%inside rec
        sample1(s,:)=[x y];
            s=s+1;
    else
        ls(i)=0;
        sample2(sn,:)=[x y]; % not c
        sn=sn+1;
    end
    if (ls (i)==1) 
        plot(x,y,'+'); 
        else plot(x,y,'go'); 
    end;
    
    else%testting set
        testsample(ss,:)=[x y];
        ss=ss+1;
    end; 
        
end
 
%m
sample_size=size(sample1)
xmean=mean(sample1(:,1))
ymean=mean(sample1(:,2))
cov_sample=cov(sample1)
s2x=mean((sample1(:,1)-xmean*ones(sample_size(1),1)).*(sample1(:,1)-xmean*ones(sample_size(1),1)));
s2y=mean((sample1(:,2)-ymean*ones(sample_size(1),1)).*(sample1(:,2)-ymean*ones(sample_size(1),1)));
sx=sqrt(s2x);
sy=sqrt(s2y);
phat=sample_size(1)/N;%P(c)
sxy=mean((sample1(:,1)-xmean*ones(sample_size(1),1)).*(sample1(:,2)-ymean*ones(sample_size(1),1)));
rxy=sxy/sqrt(s2x*s2y)

x = 0:.1:5; y = 0:.1:5;
[X,Y] = meshgrid(x,y);
X=X-xmean;Y=Y-ymean;
Z=[X(:),Y(:)];

%Now calculate the
%probabilities.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scale=((2*pi)^(d/2))*sqrt(abs(det(cov_sample))); 
p = zeros(length(Z),1);
for ii=1:length(Z)
  p(ii) = exp(-Z(ii,:)/cov_sample*Z(ii,:)'/2)/scale;%ppt page 6 mul;tivariate normal distribution
end
%Reshape and plot.

p = reshape(p,length(x),length(y));
f1=figure(1);

movegui(f1,'northeast')
figure(1)
%subplot(2,2,1)
contour(x,y,p,[.0001 .001 .01 .05:.1:.95 .99 .999 .9999]);
contour(x,y,p,0.3,'r','linewidth',2);
title('Original Normal distribution')
xlabel('x')
ylabel('y')%2D

%test error
correct=0;
for i=1:Test
    t1=testsample(i,1);
    t2=testsample(i,2);
    pt= exp(-testsample(i,:)/cov_sample*testsample(i,:)'/2)/scale;
    
        if ((t1 > xa) && (t2 > ya) && (t2 < yb) && ( t1 < xb))
           if pt>=0.3
               correct=correct+1;
               plot(t1,t2,'sg')
           else
               plot(t1,t2,'sb')
           end
        else
           
          if  pt<0.3
              
              correct=correct+1;
              plot(t1,t2,'sr')
          else
              plot(t1,t2,'sb')
          end
        end
      
end
error_rate=Test-correct

f2=figure(2);
movegui(f2,'northwest')
figure(2)
surf(x,y,p)%3D
xlabel('x')
ylabel('y')%2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
pause
close all
%normal distribution(Cov(x,y)=0)
hold on
for i=1:T
     a=ds(i,1);
     b=ds(i,2);
    if (ls (i)==1) plot(a,b,'+'); 
        else plot(a,b,'go'); 
    end;
      
    end; 
plot([xa xb xb xa xa],[ya ya yb yb ya],'-');          
     
cov_sample1=diag(diag(cov_sample))

scale=((2*pi)^(d/2))*sqrt(abs(det(cov_sample1))); 
p = zeros(length(Z),1);
for ii=1:length(Z)
  p(ii) = exp(-Z(ii,:)/cov_sample1*Z(ii,:)'/2)/scale;
end
%Reshape and plot.
p = reshape(p,length(x),length(y));
f1=figure(1);
movegui(f1,'northeast')
figure(1)
contour(x,y,p,[.0001 .001 .01 .05:.1:.95 .99 .999 .9999]);%2D
contour(x,y,p,0.3,'r','linewidth',2);
title('Cov(x,y)=0')
xlabel('x'), ylabel('y')

%test error
correct=0;
for i=1:Test
    t1=testsample(i,1);
    t2=testsample(i,2);
    pt= exp(-testsample(i,:)/cov_sample*testsample(i,:)'/2)/scale;
    
        if ((t1 > xa) && (t2 > ya) && (t2 < yb) && ( t1 < xb))
           if pt>=0.3
               correct=correct+1;
               plot(t1,t2,'sg')
           else
               plot(t1,t2,'sb')
           end
        else
          if  pt<0.3
              
              correct=correct+1;
              plot(t1,t2,'sr')
          else
              plot(t1,t2,'sb')
          end
        end
    % plot(t1,t2,'sk') 
end
error_rate=Test-correct

f2=figure(2);
movegui(f2,'northwest')
figure(2)
surf(x,y,p)%3D
xlabel('x')
ylabel('y')%2D

%equal var%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pause
close all
hold on
for i=1:T
     a=ds(i,1);
     b=ds(i,2);
    if (ls (i)==1) plot(a,b,'+'); 
        else plot(a,b,'go'); 
    end;
      
    end; 
plot([xa xb xb xa xa],[ya ya yb yb ya],'-'); 

equal_var=mean(diag(cov_sample))
cov_sample4=diag([equal_var equal_var])
scale=((2*pi)^(d/2))*sqrt(abs(det(cov_sample4))); %sample4
p = zeros(length(Z),1);
for ii=1:length(Z)
  p(ii) = exp(-Z(ii,:)/cov_sample4*Z(ii,:)'/2)/scale;%sample4
end
%Reshape and plot.
p = reshape(p,length(x),length(y));
f1=figure(1);
movegui(f1,'northeast')
figure(1)
contour(x,y,p,[.0001 .001 .01 .05:.1:.95 .99 .999 .9999]);%2D
contour(x,y,p,0.3,'r','linewidth',2);
title('Var(x)=Var(y)')
xlabel('x'), ylabel('y')


%test error
correct=0;
for i=1:Test
    t1=testsample(i,1);
    t2=testsample(i,2);
    pt= exp(-testsample(i,:)/cov_sample*testsample(i,:)'/2)/scale;
    
        if ((t1 > xa) && (t2 > ya) && (t2 < yb) && ( t1 < xb))
           if pt>=0.3
               correct=correct+1;
               plot(t1,t2,'sg')
           else
               plot(t1,t2,'sb')
           end
        else
          if  pt<0.3
              
              correct=correct+1;
              plot(t1,t2,'sr')
          else
              plot(t1,t2,'sb')
          end
        end
      
end
error_rate=Test-correct

f2=figure(2);
movegui(f2,'northwest')
figure(2)
surf(x,y,p)%3D
xlabel('x')
ylabel('y')%2D


fprintf('--------------Bayesian Network -------------------\n');
pause
close all
%Naive Bayes Classifier


%class c positive
xmean=mean(sample1(:,1))
xvar=var(sample1(:,1))
ymean=mean(sample1(:,2))
yvar=var(sample1(:,2))
%class c negtive
xmean2=mean(sample2(:,1))
xvar2=var(sample2(:,1))
ymean2=mean(sample2(:,2))
yvar2=var(sample2(:,2))

p_positive=length(sample1)/N;%P(c)
p_negative=1-p_positive;


hold on
for i=1:T
     a=ds(i,1);
     b=ds(i,2);
    if (ls (i)==1) plot(a,b,'+'); 
        else plot(a,b,'go'); 
    end;
      
    end; 
plot([xa xb xb xa xa],[ya ya yb yb ya],'-'); 
for i=0:0.1:5
   
     
    for j=0:0.1:5
%     a=testsample(i,1);
%     b=testsample(i,2);
    
    a=i;b=j;
    
    p_positive_x=exp(-(a-xmean)^2/(2*xvar^2))/sqrt(2*pi*xvar);
    p_positive_y=exp(-(b-ymean)^2/(2*yvar^2))/sqrt(2*pi*yvar);
    
    p_negative_x=exp(-(a-xmean2)^2/(2*xvar2^2))/sqrt(2*pi*xvar2);
    p_negative_y=exp(-(b-ymean2)^2/(2*yvar2^2))/sqrt(2*pi*yvar2);
    

    %with probability distribution for class
    %     p1=p_positive*p_positive_x*p_positive_y
    %     p2=p_negative*p_negative_x*p_negative_y


    
    p1=p_positive_x*p_positive_y;
    p2=p_negative_x*p_negative_y;


   if p1>p2
        plot(a,b,'sg')
    else
        plot(a,b,'sr')
    end

   end
end

correct=0;
for i=1:Test
    a=testsample(i,1);
    b=testsample(i,2);
    
     p_positive_x=exp(-(a-xmean)^2/(2*xvar^2))/sqrt(2*pi*xvar);
    p_positive_y=exp(-(b-ymean)^2/(2*yvar^2))/sqrt(2*pi*yvar);
    
    p_negative_x=exp(-(a-xmean2)^2/(2*xvar2^2))/sqrt(2*pi*xvar2);
    p_negative_y=exp(-(b-ymean2)^2/(2*yvar2^2))/sqrt(2*pi*yvar2);
    
   
    p1=p_positive_x*p_positive_y;
    p2=p_negative_x*p_negative_y;
    
      if ((a > xa) && (b > ya) && (b < yb) && ( a < xb))
           if p1>p2
               correct=correct+1;
           end
      else
          if p1<p2
              correct=correct+1;
          end
      end

      
end
error_rate=Test-correct
   
%%
% N = 3; 
% xb = 1; yb = 2;cb = 3;%creat bayes network
% dag = zeros(N,N);
% dag(xb,cb) = 1;
% dag(yb,cb) = 1;
% 
% node_sizes = [1 1 2];
% bnet = mk_bnet(dag, node_sizes,'discrete',cb);
% 
% w = [0 5;5 0];  % w(:,i) is the normal vector to the i'th decisions boundary
% b = [0 0];  % b(i) is the offset (bias) to the i'th decisions boundary
% bnet.CPD{xb} = root_CPD(bnet, xb);
% bnet.CPD{yb} = root_CPD(bnet, yb);
% bnet.CPD{cb} = softmax_CPD(bnet, cb,w,b);%
% engine = jtree_inf_engine(bnet);%junction tree engine
% 
% 
% 
% bsamples=num2cell([ds(1:T,:) ls(1:T,:)+1 ]' );% x y l
% bnet2 = mk_bnet(dag, node_sizes,'discrete',cb);
% seed = 0;
% rand('state', seed);
% bnet2.CPD{xb} = root_CPD(bnet2, xb);
% bnet2.CPD{yb} = root_CPD(bnet2, yb);
% bnet2.CPD{cb} = softmax_CPD(bnet2, cb,w,b);%
% bnet3 = learn_params(bnet2, bsamples);
% %samples
% engine = jtree_inf_engine(bne3t);
% hold on
% for i=1:Test
%     a=testsample(i,1);
%     b=testsample(i,2);
%     [engine, loglik] = enter_evidence(engine, {a, b,[]});
%     Qpost = marginal_nodes(engine, 3);
%    Qpost.T(2);
%   
%    
%     if Qpost.T(2)>0.2
%         plot(a,b,'sg')
%     else
%         plot(a,b,'sr')
%     end
% end


% plot(LLtrace, 'x-r','linewidth',2)
% xlabel('iteration')
% ylabel('log-likelihood')

% CPT3=cell(1,N);
% 
% s=struct(bnet2.CPD{3});  % violate object privacy
% CPD=s.discrete_CPD.generic_CPD;
% dispcpt(CPD)


fprintf('--------------Result of Bayesian Network -------------------\n');

